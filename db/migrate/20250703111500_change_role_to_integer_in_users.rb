class ChangeRoleToIntegerInUsers < ActiveRecord::Migration[7.0]
  def up
    # 1. Добавить новое integer-поле role_int с default: 0 (user)
    add_column :users, :role_int, :integer, default: 0, null: false

    # 2. Обновить значения на основе string role
    User.reset_column_information
    User.find_each do |user|
      user.update_column(:role_int, user.role == 'admin' ? 1 : 0)
    end

    # 3. Удалить старое string-поле и переименовать новое
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
