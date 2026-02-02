class Order < ApplicationRecord
  belongs_to :user

  # Money-Rails (wie in Lecture)
  monetize :amount_cents, with_currency: :eur

  # Validations
  validates :state, presence: true
  validates :plan, presence: true
end
