class AddCategoryToBlogs < ActiveRecord::Migration[7.0]
  def change
    add_column :blogs, :category, :string, null: false, default: 'путешествие'
  end
end
