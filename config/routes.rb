Rails.application.routes.draw do

  #devise_for :users
  
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  devise_scope :user do
    root to: "users/sessions#new"
  end
  #root to: "home#index"
  resources :service_types
  resources :parcels
  resources :users
  resources :addresses
  
  post '/users/create_user', to: 'users#create_user'

  #root to: "parcels#index"
  get '/parcels', to: 'parcels#index'
  get '/parcels/parcel_export_files', to: 'parcels#parcel_export_files'
  get 'parcel_export_files', to: 'parcels#parcel_export_files'
  get '/parcels/change_status/:id', to: 'parcels#change_status'
  post '/parcels/update_status/:id', to: 'parcels#update_status'
  get '/parcels/history/:id', to: 'parcels#history'
  get '/search', to: 'search#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
