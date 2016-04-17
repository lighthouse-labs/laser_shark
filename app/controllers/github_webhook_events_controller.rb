class GithubWebhookEventsController < ApplicationController

  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user
  skip_before_action :set_timezone

  def create
    if params[:payload].present?
      response = HandleGithubWebhookPayload.call(payload: params[:payload])
    end
    render text: "Thanks, Github", status: 200
  end

end
