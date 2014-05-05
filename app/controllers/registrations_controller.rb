class RegistrationsController < ApplicationController

  before_action :must_be_unregistered

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.completed_registration = true
    if @user.update_attributes(user_params)
      redirect_to root_url
    else
      render :edit
    end
  end

  private

  def must_be_unregistered
    redirect_to root_url if current_user.completed_registration?
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :skype, :twitter)
  end

end
