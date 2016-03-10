LaserShark::Application.routes.draw do

  match "/websocket", :to => ActionCable.server, via: [:get, :post]

  get '/i/:code', to: 'invitations#show' # student/teacher invitation handler
  # get 'prep'  => 'setup#show' # temporary
  resources :prep, param: :number, :only => [:show]
  get 'setup' => 'setup#show' # temporary

  root to: 'home#show'
  get '/welcome', to: 'welcome#show'

  # STUDENT / TEACHER AUTH
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/github', as: 'github_session'
  resource :session, :only => [:new, :destroy]
  # resource :registration, only: [:new, :create]
  resource :profile, only: [:edit, :update]
  resources :feedbacks, only: [:index, :update] do 
    member do 
      get :modal_content
    end
  end

  resources :assistance_requests, only: [:index, :create, :destroy] do
    collection do
      delete :cancel
      get :status
      get :queue
    end
    member do
      post :start_assistance
    end
  end

  resources :students, only: [:index, :show] do
    resources :assistances, only: [:create]
  end

  resources :incomplete_activities, only: [:index]
  resources :search_activities, only: [:index]

  resources :assistances, only: [:destroy] do
    member do
      post :end
    end
  end

  # CONTENT BROWSING
  resources :days, param: :number, only: [:show] do
    resources :activities, only: [:new, :create, :show, :edit, :update]
    resources :feedbacks, only: [:create, :new], controller: :day_feedbacks

    resource :info, only: [:edit, :update], controller: 'day_infos'
  end

  resources :activities, only: [] do
    resource :activity_submission, only: [:create, :destroy]
    resources :messages, controller: 'activity_messages'
    resources :recordings, only: [:new, :create]
  end

  resources :cohorts, only: [] do
    resources :students, only: [:index]    # cohort_students_path(@cohort)
    put :switch_to, on: :member
  end

  resources :recordings

  resources :streams, only: [:index, :show]

  resources :teachers, only: [:index, :show] do
    member do 
      get :feedback
      post :remove_mentorship
      post :add_mentorship
    end
  end

  # ADMIN
  namespace :admin do
    root to: 'dashboard#show'
    resources :students, only: [:index, :update, :edit] do 
      member do 
        post :reactivate
        post :deactivate 
        get :modal_content
      end
    end
    resources :teacher_stats, only: [:index, :show] do 
      member do
        get :assistance
        get :feedback
      end
    end
    resources :cohorts, except: [:destroy]
    resources :feedbacks, except: [:edit, :update, :destroy]
    resources :teacher_feedbacks, only: [:index]
    resources :curriculum_feedbacks, only: [:index]
    resources :day_feedbacks, except: [:destroy] do 
      member do 
        post :archive
        delete :archive, action: :unarchive
      end
    end
  end

  # To test 500 error notifications on production
  get 'error-test' => 'test_errors#create'

end
