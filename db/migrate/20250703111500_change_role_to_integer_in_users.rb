class ChangeRoleToIntegerInUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :role_int, :integer, default: 0, null: false
    User.reset_column_information
    User.find_each do |user|
      user.update_column(:role_int, user.role == 'admin' ? 1 : 0)
    end

    remove_column :users, :role, :string
    rename_column :users, :role_int, :role
  end

  def down
    add_column :users, :role_str, :string, default: 'user', null: false
    User.reset_column_information
    User.find_each do |user|
      user.update_column(:role_str, user.role == 1 ? 'admin' : 'user')
    end
    remove_column :users, :role, :integer
    rename_column :users, :role_str, :role
  end
end
