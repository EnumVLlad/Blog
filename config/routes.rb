Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  resources :blogs, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :comments, only: [:create, :destroy]
    resources :likes, only: [:create]
  end
  get 'users', to: 'users#index'

  # Stripe backend payments
  resources :payments, only: [:new, :create] do
    collection do
      post :create_payment_intent
      get :complete
    end
  end

  # Описуйте маршрути вашого застосунку відповідно до DSL: https://guides.rubyonrails.org/routing.html

  # Перевірка стану на /up: повертає 200, якщо застосунок стартує без помилок, інакше 500.
  # Використовується балансувачами навантаження та моніторами часу роботи для перевірки того, чи застосунок працює.
  get "up" => "rails/health#show", as: :rails_health_check

  # Визначає кореневий маршрут ("/")
  # root "posts#index"
end
