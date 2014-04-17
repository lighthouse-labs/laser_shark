class ProfilesController < ApplicationController

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
