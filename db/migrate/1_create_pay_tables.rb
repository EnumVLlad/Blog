# Миграция очищена: создание pay-таблиц удалено
  # Очищено при удалении pay gem
end
  def change
    primary_key_type = :bigint
    foreign_key_type = :bigint

    create_table :pay_customers, id: primary_key_type do |t|
      t.belongs_to :owner, polymorphic: true, index: false, type: foreign_key_type
      t.string :processor, null: false
      t.string :processor_id
      t.boolean :default
      t.public_send Pay::Adapter.json_column_type, :data
      t.string :stripe_account
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :pay_customers, [:owner_type, :owner_id, :deleted_at], name: :pay_customer_owner_index, unique: true
    add_index :pay_customers, [:processor, :processor_id], unique: true

    create_table :pay_merchants, id: primary_key_type do |t|
      t.belongs_to :owner, polymorphic: true, index: false, type: foreign_key_type
      t.string :processor, null: false
      t.string :processor_id
      t.boolean :default
      t.public_send Pay::Adapter.json_column_type, :data
      t.timestamps
    end
    add_index :pay_merchants, [:owner_type, :owner_id, :processor]

    create_table :pay_payment_methods, id: primary_key_type do |t|
      t.belongs_to :customer, foreign_key: {to_table: :pay_customers}, null: false, index: false, type: foreign_key_type
      t.string :processor_id, null: false
      t.boolean :default
      t.string :type
      t.public_send Pay::Adapter.json_column_type, :data
      t.string :stripe_account
      t.timestamps
    end
    add_index :pay_payment_methods, [:customer_id, :processor_id], unique: true

    create_table :pay_subscriptions, id: primary_key_type do |t|
      t.belongs_to :customer, foreign_key: {to_table: :pay_customers}, null: false, index: false, type: foreign_key_type
      t.string :name, null: false
      t.string :processor_id, null: false
      t.string :processor_plan, null: false
      t.integer :quantity, default: 1, null: false
      t.string :status, null: false
      t.datetime :current_period_start
      t.datetime :current_period_end
      t.datetime :trial_ends_at
      t.datetime :ends_at
      t.boolean :metered
      t.string :pause_behavior
      t.datetime :pause_starts_at
      t.datetime :pause_resumes_at
      t.decimal :application_fee_percent, precision: 8, scale: 2
      t.public_send Pay::Adapter.json_column_type, :metadata
      t.public_send Pay::Adapter.json_column_type, :data
      t.string :stripe_account
      t.string :payment_method_id
      t.timestamps
    end
  end
end
