LaserShark::Application.routes.draw do

  get 'prep' => 'prep#show'

  root to: 'home#show'
  get '/welcome', to: 'welcome#show'

  # STUDENT / TEACHER AUTH
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/github', as: 'github_session'
  resource :session, :only => [:new, :destroy]
  resource :registration, only: [:new, :create]
  resource :profile, only: [:edit, :update]

  resources :assistance_requests, only: [:index, :create, :destroy] do
    collection do
      delete :cancel
    end
    member do
      post :start_assistance
    end
  end

  resources :students, only: [] do
    resources :assistances, only: [:create]
  end

  resources :assistances, only: [] do
    member do
      post :end
    end
  end

  # CONTENT BROWSING
  resources :days, param: :number, only: [:show] do
    resources :activities, only: [:show, :edit, :update]
  end

  resources :activities, only: [] do
    resource :activity_submission, only: [:create, :destroy]
  end

  resources :activities do 
    resources :comments, only: [:create]
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
