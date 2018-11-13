Rails.application.routes.draw do

    devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
   }
   
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :welcome, :only => [:index]
  root "welcome#index"
  resources :users, :only => [:show, :index]
  post "band_details/:user_id/create" => "band_details#create"
  # post "band_detail/user_id/destroy" => "band_details#destroy"
  resources :band_details
 
  get "users/:id/likes" => "users#likes"
  

  post 'friends/:id' => 'friends#create'
  resources :friends
  # post 'friends/new' => 'friends#create'
  # resources :friends, :only => [:index]
  # devise_for :users  
  
  resources :posts
  
  post "likes/:post_id/:post_detail_id/create" => "likes#create"
  post "likes/:post_id/:post_detail_id/destroy" => "likes#destroy"
  
end
