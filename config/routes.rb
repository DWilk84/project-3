Pixelpic::Application.routes.draw do

  resources :mosaics


  devise_for :users, controllers: {registrations: "users"}

  resources :images

  root to: "images#index"
end
