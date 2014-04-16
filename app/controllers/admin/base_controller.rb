class Admin::BaseController < ApplicationController
  
  http_basic_authenticate_with name:, password:

  def index
    render admin: "Thanks for logging in."
  end

  def edit
    render admin: "Edit your account."
  end

  def show
    @admin = Admin.find(params[:id])
  end

end
