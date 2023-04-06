Rails.application.routes.draw do
  devise_for :users
  get 'pages/index'
  root "pages#index"
  
  get 'profile', to: "users#show"

  get '/posts', to: "posts#index"
  get 'posts/new'
  post 'posts/new', to: "posts#create", as: :new_post
end
