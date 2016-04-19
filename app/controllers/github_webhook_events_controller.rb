class GithubWebhookEventsController < ApplicationController

  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user
  skip_before_action :set_timezone

  before_filter :ensure_valid_signature

  def create
    response = HandleGithubWebhookPayload.call(payload: @payload)
    render text: "Thanks, Github", status: 200
  end

  private 

  def ensure_valid_signature
    request.body.rewind
    @payload = request.body.read
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['GITHUB_WEBHOOK_SECRET'], @payload)
    render text: "Not a valid secret", status: 401 unless valid_sig?(signature)
  end

  def valid_sig?(signature)
    Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end

end
