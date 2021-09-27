Rails.application.routes.draw do
  get 'sessions/new'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#home'
  resources :siteusers
  resources :accountactivations, only: [:edit]
  resources :passwordresets, only: [:new, :create, :edit, :update]
  namespace :siteadmin do
    resources :siteusers, only: [:index, :show] do
      get 'approve', on: :member
    end
  end

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

end
