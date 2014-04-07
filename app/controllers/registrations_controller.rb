class RegistrationsController < ApplicationController

  def new
    @form = RegistrationForm.new(current_student)
  end

  def create
    @form = RegistrationForm.new(current_student)
    @form.completed_registration = true
    if @form.validate(params[:student]) && @form.save
      redirect_to root_url
    else
      render :new
    end
  end

end
