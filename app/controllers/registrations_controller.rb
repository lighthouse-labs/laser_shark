class RegistrationsController < ApplicationController

  def new
    if current_student.completed_registration 
      redirect_to root_url
    else
      @form = RegistrationForm.new(current_student)
    end
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

  # DELETE /registration
  def destroy 
    current_student.destroy
    reset_session
    redirect_to root_path
  end

end
