Rails.application.routes.draw do
  get 'blogs/index'
  devise_for :users
  root to: 'home#index'
  get 'blogs', to: 'blogs#index'
  get 'blogs/new', to: 'blogs#new', as: 'new_blog'
  post 'blogs', to: 'blogs#create'
  get 'blogs/:id/edit', to: 'blogs#edit', as: 'edit_blog'
  patch 'blogs/:id', to: 'blogs#update', as: 'blog'
  delete 'blogs/:id', to: 'blogs#destroy'
  get 'users', to: 'users#index'
  # Описуйте маршрути вашого застосунку відповідно до DSL: https://guides.rubyonrails.org/routing.html

  # Перевірка стану на /up: повертає 200, якщо застосунок стартує без помилок, інакше 500.
  # Використовується балансувачами навантаження та моніторами часу роботи для перевірки того, чи застосунок працює.
  get "up" => "rails/health#show", as: :rails_health_check

  # Визначає кореневий маршрут ("/")
  # root "posts#index"
end
