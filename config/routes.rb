Rails.application.routes.draw do

  ActiveAdmin.routes(self)
  # namespace :admin do
  #   resources :users
  #   resources :blogs
  #   resources :comments
  #   root to: 'dashboard#index'
  # end
  devise_for :users

  # Для совместимости с ActiveAdmin, чтобы не было ошибки
  devise_scope :user do
    delete '/admin_users/sign_out', to: 'devise/sessions#destroy', as: :destroy_admin_user_session
  end
  root to: 'home#index'
  resources :blogs, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :comments, only: [:create, :destroy]
    resources :likes, only: [:create]
  end
  resources :users, only: [:index, :destroy, :edit, :update] do
    member do
      patch :update_role
    end
  end

  # Stripe backend payments
  resources :payments, only: [:new, :create] do
    collection do
      post :create_payment_intent
      get :complete
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
