class CreateBlogAccesses < ActiveRecord::Migration[7.1]
  def change
    create_table :blog_accesses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :blog, null: false, foreign_key: true

      t.timestamps
    end
  end
end
