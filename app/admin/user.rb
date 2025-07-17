ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :role

  controller do
    def index
      redirect_to users_path
    end
  end

  index do
    selectable_column
    id_column
    column :email
    column :role
    column :created_at
    actions
  end

  filter :email
  filter :role, as: :select, collection: User.roles.keys
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :role, as: :select, collection: User.roles.keys
    end
    f.actions
  end
end
