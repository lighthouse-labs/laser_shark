class RegistrationsController < ApplicationController

  before_action :must_be_unregistered 

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

  private

  def must_be_unregistered
    redirect_to root_url if current_student.completed_registration?
  end

end
