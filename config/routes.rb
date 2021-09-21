Rails.application.routes.draw do
  resources :likes
  resources :friendships
  resources :friend_requests
  resources :commnets
	root to: 'posts#index'
  resources :posts
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
	
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
