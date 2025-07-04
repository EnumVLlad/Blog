class CreateBlogs < ActiveRecord::Migration[7.1]
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :body
      t.references :user, null: false, foreign_key: true
      t.integer :views, default: 0, null: false
      t.timestamps
    end
  end
end
