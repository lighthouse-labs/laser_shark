class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: [:new, :create]

  def new
    binding.pry
    if current_user
      redirect_to day_path('today')
    end
  end

  def create
    @current_user = User.authenticate_via_github auth_hash_params
    session[:user_id] = @current_user.id
    cookies.signed[:user_id] = @current_user.id
    if @current_user.completed_registration?
      if session[:invitation_code]
        apply_invitation_code(session[:invitation_code])
        session[:invitation_code] = nil
      end
      # Ok they are ready to go and fully registered
      if destination_url = session[:attempted_url]
        session[:attempted_url] = nil
        redirect_to destination_url
      else
        redirect_to :root
      end
    else
      redirect_to [:edit, :profile]
    end
  end

  def destroy
    reset_session
    cookies.delete :user_id
    redirect_to :root
  end

  protected

  def auth_hash_params
    request.env['omniauth.auth']
  end

end
