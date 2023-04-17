Rails.application.routes.draw do
  devise_for :users
  get 'pages/index'
  root "pages#index"
  
  get 'profile/:username', to: "users#show", as: :profile

  get '/posts/:username', to: "users#posts", as: :user_posts
  get 'post/new', to: "posts#new"
  post 'post/new', to: "posts#create", as: :new_post
  get 'friends', to: "users#friends"
  get 'users', to: "users#index"
  delete 'posts/:id', to: "posts#destroy", as: :delete_post

  post 'add_friend', to: "users#add_friend"
  get 'invites', to: "users#invites"
  post 'accept_invite', to: "users#accept_invite"
  delete 'deny_invite', to: "users#deny_invite"

  get '/settings', to: "users#settings"
  patch '/settings', to: "users#update_settings", as: :update_settings

  get 'search', to: "users#search"
  get 'feed', to: "users#feed"
end
