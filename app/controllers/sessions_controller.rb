class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: [:create]

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
    redirect_to github_session_path
  end

  protected

  def auth_hash_params
    request.env['omniauth.auth']
  end

end
