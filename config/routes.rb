LaserShark::Application.routes.draw do

  root to: 'home#show'

  namespace :admin do
  	resources :cohorts
  end

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/github', as: 'github_session'

  resource :registration, only: [:new, :create]

end
