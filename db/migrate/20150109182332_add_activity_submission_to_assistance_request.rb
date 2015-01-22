class AddActivitySubmissionToAssistanceRequest < ActiveRecord::Migration
  def change
    add_reference :assistance_requests, :activity_submission, index: true
  end
end
