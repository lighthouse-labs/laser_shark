LaserShark::Application.routes.draw do

  root to: 'home#show'
  get '/welcome', to: 'welcome#show'

  # SEARCH
  resources :activities, only: [] do
    get :search, on: :collection
  end

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


  resources :cohorts, only: [] do
    resources :students, only: [:index]    # cohort_students_path(@cohort)
    put :switch_to, on: :member
  end


  # ADMIN
  namespace :admin do
    root to: 'dashboard#show'
    resources :students, only: [:index]
    resources :cohorts, only: [:index]
  end

end
