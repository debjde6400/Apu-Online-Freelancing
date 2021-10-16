Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'application#home'
  get "dashboard", to: "application#dashboard"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :accountactivations, only: [:edit]
  resources :passwordresets, only: [:new, :create, :edit, :update]

  namespace :siteadmin do
    resources :siteusers, only: [:index, :show] do
      get 'approve', on: :member
    end
  end

  resources :siteusers do
    scope '/client' do
      resources :projects, shallow: true
      get 'posted_projects', on: :member
    end

    scope '/freelancer' do
      get 'current_bids', on: :member
    end
  end

  resources :projects, only: [] do
    get 'all_projects', on: :collection
    scope '/freelancer' do
      get 'freelancer_files', on: :member
      patch 'send_files', on: :member
    end
    
    resources :bids, shallow: true do
      scope '/client' do
        get 'award', on: :member
      end
    end
  end

  delete "attachments/:id/remove", to: "application#remove_attachment", as: "remove_attachment"

  resources :conversations do
    resources :messages
  end

end
