LaserShark::Application.routes.draw do

  root to: 'home#show'
  namespace :admin do
  	resources :cohorts
  end
end
