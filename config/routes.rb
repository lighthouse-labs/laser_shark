LaserShark::Application.routes.draw do

  root to: 'home#show'
  get '/welcome', to: 'welcome#show'

  # STUDENT / TEACHER AUTH
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/github', as: 'github_session'
  resource :session, :only => [:new, :destroy]
  resource :registration, only: [:new, :create]
  resource :profile, only: [:edit, :update]

  # CONTENT BROWSING
  resources :days, param: :number, only: [:show] do
    resources :activities, only: [:show]
  end

  resources :activities do 
    resources :comments, only: [:create]
  end

  resources :cohorts, only: [] do
    put :switch_to, on: :member
  end

  # ADMIN
  namespace :admin do
    root to: 'dashboard#show'
    resources :students, only: [:index]
    resources :cohorts, only: [:index]
  end

end
