LaserShark::Application.routes.draw do

  root to: 'home#show'

  # STUDENT AUTH
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/github', as: 'github_session'
  resource :session, :only => [:destroy]
  resource :registration, only: [:new, :create]
  resource :profile, only: [:edit, :update]

  # CONTENT BROWSING
  resources :days, param: :day, only: [:show]

  # ADMIN
  namespace :admin do
    root to: 'dashboard#show'
    resources :students, only: [:index]
    resources :cohorts, only: [:index]
  end

end
