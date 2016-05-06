class AssistanceRequestSubmissionToActivity < ActiveRecord::Migration
  def change
    # Looks like AR does not support UPDATE with joins, so we batch this!
    batch_size = 100
    begin
      assistance_requests = AssistanceRequest.where.not(activity_submission_id: nil).limit(batch_size)
      assistance_requests.each do |ar|
        ar.update!({
          activity_id: ar.activity_submission.activity_id,
          original_activity_submission_id: ar.activity_submission.activity_id,
          activity_submission_id: nil
        })
      end
    end until assistance_requests.empty?

  end
end
