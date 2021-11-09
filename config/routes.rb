Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/siteadmin', as: 'rails_admin'
  
  root 'application#home'
  get "dashboard", to: "application#dashboard"
  get "read_notification", to: "application#read_notification"
  delete "attachments/:id/remove", to: "application#remove_attachment", as: "remove_attachment"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :accountactivations, only: [:edit]
  resources :passwordresets, only: [:new, :create, :edit, :update]

  resources :projects, only: [] do
    get 'all_projects', on: :collection
    get 'freelancer_files', on: :member
    patch 'send_files', on: :member
    
    resources :bids, shallow: true do
      get 'award', on: :member
    end
  end

  resources :siteusers do
    resources :projects, shallow: true
    get 'search_freelancers', on: :collection
    get 'bid_history', on: :member
  end


  resources :conversations do
    resources :messages
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
