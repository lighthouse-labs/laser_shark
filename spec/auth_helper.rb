module AuthHelper

  def set_valid_auth
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('admin', ENV['ADMIN_PASSWORD'])
  end

  def set_invalid_auth
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'fdsadsafpassword')
  end

end
