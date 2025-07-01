class AddCascadeDeleteToForeignKeys < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :blogs, :users
    add_foreign_key :blogs, :users, on_delete: :cascade

    remove_foreign_key :comments, :users
    remove_foreign_key :comments, :blogs
    add_foreign_key :comments, :users, on_delete: :cascade
    add_foreign_key :comments, :blogs, on_delete: :cascade

    remove_foreign_key :likes, :users
    remove_foreign_key :likes, :blogs
    add_foreign_key :likes, :users, on_delete: :cascade
    add_foreign_key :likes, :blogs, on_delete: :cascade
  end
end
