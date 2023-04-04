Rails.application.routes.draw do
  devise_for :users
  get 'pages/index'
  root "pages#index"

  get 'profile', to: "users#show"
end
