Rails.application.routes.draw do
  devise_for :users
  get 'pages/index'
  root "pages#index"
  
  get 'profile/:id', to: "users#show", as: :profile

  get '/posts/:user_id', to: "users#posts", as: :user_posts
  get 'post/new', to: "posts#new"
  post 'post/new', to: "posts#create", as: :new_post
  get 'friends', to: "users#friends"
  get 'users', to: "users#index"

  post 'add_friend', to: "users#add_friend"
  get 'invites', to: "users#invites"
  post 'accept_invite', to: "users#accept_invite"
  delete 'deny_invite', to: "users#deny_invite"

  get '/settings', to: "users#settings"
  patch '/settings', to: "users#update_settings"

  get 'search', to: "users#search"
  get 'feed', to: "users#feed"
end
