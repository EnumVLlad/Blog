class AddPaidToBlogs < ActiveRecord::Migration[7.1]
  def change
    add_column :blogs, :paid, :boolean
  end
end
