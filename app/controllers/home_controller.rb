class HomeController < ApplicationController

  skip_before_action :authenticate_user

  def show
    if current_user
      redirect_to setup_path
    else
      redirect_to welcome_path
    end
  end

end
