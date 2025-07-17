ActiveAdmin.register Blog do
  controller do
    def index
      redirect_to blogs_path(locale: :en)
    end
  end
  permit_params :title, :content, :category, :paid, :views, :user_id

  index do
    selectable_column
    id_column
    column :title
    column :category
    column :paid
    column :views
    column :user
    column :created_at
    actions
  end

  filter :title
  filter :category
  filter :paid
  filter :user
  filter :created_at

  form do |f|
    f.inputs do
      f.input :title
      f.input :content
      f.input :category
      f.input :paid
      f.input :views
      f.input :user
    end
    f.actions
  end
end
