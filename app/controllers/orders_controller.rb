class OrdersController < ApplicationController
  before_action :authenticate_user!

  # Pricing (in cents) - wie in Lecture
  PRICES = {
    'starter' => 990,      # 9.90 EUR
    'pro' => 2990,         # 29.90 EUR
    'enterprise' => 9990   # 99.90 EUR
  }

  def create
    @order = Order.create!(
      user: current_user,
      plan: params[:plan],
      amount_cents: PRICES[params[:plan]],
      state: 'pending'
    )

    # Stripe Checkout Session (Lecture-Style)
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          unit_amount: @order.amount_cents,
          currency: 'eur',
          product_data: { name: "Pluto AI - #{@order.plan.capitalize} Plan" }
        },
        quantity: 1
      }],
      mode: 'payment',
      success_url: order_url(@order),
      cancel_url: pricing_url
    )

    @order.update(stripe_payment_link_id: session.id)
    redirect_to session.url, allow_other_host: true
  end

  def show
    @order = current_user.orders.find(params[:id])
    @order.update(state: 'paid') if @order.state == 'pending'
  end
end
