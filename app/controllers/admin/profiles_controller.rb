class Admin::ProfilesController < Admin::BaseController
    
  before_action :load_user, only: [:edit, :update]

  def edit
  end

  def update
    if @user.update profile_params
      redirect_to root_url
    else
      render :edit
    end
  end

  private

  def profile_params
    params.require(:user).permit(
        :first_name,
        :last_name,
        :phone_number,
        :email,
        :location_id,
        :receive_feedback_emails
      )
  end

  def load_user
    @user = current_user
  end

end
