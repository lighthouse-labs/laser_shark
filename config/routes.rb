LaserShark::Application.routes.draw do

  root to: 'home#show'

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/github', as: 'github_session'

  resource :session, :only => [:destroy]

  resource :registration, only: [:new, :create]
  
  resource :profile, only: [:edit, :update]

  namespace :admin do
    root to: 'dashboard#show'
    resources :students, only: [:index] 
  end

end
