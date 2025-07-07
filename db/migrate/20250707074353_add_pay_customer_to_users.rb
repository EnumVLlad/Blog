class AddPayCustomerToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :pay_customer_id, :string
    add_column :users, :pay_processor, :string
    add_column :users, :pay_data, :text
  end
end
