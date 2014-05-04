class Admin::BaseController < ApplicationController

  http_basic_authenticate_with name: 'admin' , password: 'password'

  skip_before_action :authenticate_user

  layout 'admin'

end
