Rails.application.routes.draw do
  devise_for :users
  root to: "recipes#home"

  resources :chats, except: [:edit, :update] do
    resources :recipes, only: [:create]
    resources :messages, except: [:new]
  end
  resources :recipes, only: [:destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
