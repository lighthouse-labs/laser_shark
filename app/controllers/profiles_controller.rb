class ProfilesController < ApplicationController

  protect_from_forgery with: :exception
  before_action :authenticate

  def edit
    @form = RegistrationForm.new(current_student)
  end

  def update
    @form = RegistrationForm.new(current_student)
    if @form.validate(params[:student]) && @form.save
      redirect_to root_url
    else
      render :edit
    end
  end  
end

#These actions should operate on current_student
#GET the form(edit)
#POST to send the form(update)



 


  