class Admin::ProfilesController < Admin::BaseController
    
  before_action :load_user, only: [:edit, :update]

  def edit
  end

  def update
  end

  private

  def load_user
    @user = current_user
  end

end
