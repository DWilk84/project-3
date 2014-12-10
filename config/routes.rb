Pixelpic::Application.routes.draw do

  root to: "pages#index"
  # match "/home" => "pages#index"

  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}, controllers: {omniauth_callbacks: "omniauth_callbacks", registrations: "users"}

  resources :images
  resources :mosaics

end
