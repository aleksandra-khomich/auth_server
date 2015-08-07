Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  root 'doorkeeper/applications#index'
  get '/users/login_with_twitter', to: 'users#login_with_twitter'
  get 'me', to: 'users#me'
  get 'user_info', to: 'users#user_info'
  post '/users/update', to: 'users#update'
  post '/users/confirm_email', to: 'users#confirm_email'
  post '/users/create', to: 'users#create'
end
