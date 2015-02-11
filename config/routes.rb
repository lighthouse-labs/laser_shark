LaserShark::Application.routes.draw do

  get '/invitations/:code', to: 'invitations#show'
  get '/i/:code', to: 'invitations#show' # alias for above

  get 'prep'  => 'setup#show' # temporary
  get 'setup' => 'setup#show' # temporary

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
    resources :feedbacks, only: [:create, :new], controller: :day_feedbacks
  end

  resources :activities, only: [] do
    resource :activity_submission, only: [:create, :destroy]
  end

  resources :cohorts, only: [] do
    resources :students, only: [:index]    # cohort_students_path(@cohort)
    put :switch_to, on: :member
  end


  # ADMIN
  namespace :admin do
    root to: 'dashboard#show'
    resources :students, only: [:index, :create, :edit, :update, :show]
    resources :cohorts, only: [:index]
    resources :teachers, only: [:index, :create, :edit, :update, :show]
  end

  # To test 500 error notifications on production
  get 'error-test' => 'test_errors#create'

end
