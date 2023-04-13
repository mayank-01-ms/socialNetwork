Rails.application.routes.draw do
  devise_for :users
  get 'pages/index'
  root "pages#index"
  
  get 'profile/:id', to: "users#show", as: :profile

  get '/posts/:user_id', to: "users#posts", as: :user_posts
  get 'posts/new'
  post 'posts/new', to: "posts#create", as: :new_post
  get 'friends', to: "users#friends"
  get 'users', to: "users#index"

  post 'add_friend', to: "users#add_friend"
  get 'invites', to: "users#invites"

  get '/settings', to: "users#settings"
  patch '/settings', to: "users#update_settings"
end
