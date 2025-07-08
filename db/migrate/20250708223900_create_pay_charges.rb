class CreatePayCharges < ActiveRecord::Migration[6.0]
  def change
    create_table :pay_charges, id: :bigint do |t|
      t.belongs_to :customer, foreign_key: {to_table: :pay_customers}, null: false, index: false, type: :bigint
      t.string :processor_id, null: false
      t.integer :amount, null: false
      t.string :currency, null: false
      t.integer :application_fee_amount
      t.integer :amount_refunded
      t.string :card_type
      t.string :card_last4
      t.integer :card_exp_month
      t.integer :card_exp_year
      t.string :card_brand
      t.string :status
      t.string :failure_code
      t.string :failure_message
      t.string :payment_method_type
      t.string :stripe_account
      t.jsonb :data
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
    add_index :pay_charges, [:customer_id, :processor_id], unique: true
  end
end
