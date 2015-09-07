class Admin::BaseController < ApplicationController

  # skip_before_action :authenticate_user

  before_filter :admin_required

  layout 'admin'

  private

  def admin_required
    unless admin?
      flash[:alert] = 'Access Not Allowed'
      redirect_to :root
    end
  end

end
