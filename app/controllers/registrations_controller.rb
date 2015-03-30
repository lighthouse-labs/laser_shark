class RegistrationsController < ApplicationController

  before_action :must_be_unregistered

  def new
    @form = RegistrationForm.new(current_user)
  end

  def create
    @form = RegistrationForm.new(current_user)
    @form.completed_registration = true
    if @form.validate(params[:user]) && @form.save
      if session[:invitation_code]
        apply_invitation_code(session[:invitation_code])
        session[:invitation_code] = nil
      end
      redirect_to root_url
    else
      render :new
    end
  end

  private

  def must_be_unregistered
    redirect_to root_url if current_user.completed_registration?
  end

end
