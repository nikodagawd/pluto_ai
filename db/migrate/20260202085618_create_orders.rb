class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :state
      t.references :user, null: false, foreign_key: true
      t.string :plan
      t.string :stripe_payment_link_id
      t.integer :amount_cents

      t.timestamps
    end
  end
end
