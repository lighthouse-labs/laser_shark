class HomeController < ApplicationController

  skip_before_action :authenticate_student

  def show
  end
  
end
