LaserShark::Application.routes.draw do

  root to: 'home#show'

  # STUDENT / TEACHER AUTH
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/github', as: 'github_session'
  resource :session, :only => [:new, :destroy]
  resource :registration, only: [:new, :create]
  resource :profile, only: [:edit, :update]

  # CONTENT BROWSING
  resources :days, param: :number, only: [:show] do
    resources :activities do 
      resources :comments do 
      end
    end
  end



  resources :cohorts, only: [] do
    put :switch_to, on: :member
  end

  # ACTIVITY COMMENTING
  # resources :activities do 
  #   resources :comments
  # end

  # ADMIN
  namespace :admin do
    root to: 'dashboard#show'
    resources :students, only: [:index]
    resources :cohorts, only: [:index]
  end

end
