class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: [:new, :create]

  def new
    if current_user
      redirect_to day_path('today')
    end
  end

  def create
    @current_user = User.authenticate_via_github auth_hash_params
    session[:user_id] = @current_user.id
    if @current_user.completed_registration?
      redirect_to :root
    else
      redirect_to [:new, :registration]
    end
  end

  def destroy
    reset_session
    redirect_to :root
  end

  protected

  def auth_hash_params
    request.env['omniauth.auth']
  end

end
