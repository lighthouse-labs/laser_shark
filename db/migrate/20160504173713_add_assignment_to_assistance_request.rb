class AddAssignmentToAssistanceRequest < ActiveRecord::Migration
  def change
    add_column :assistance_requests, :activity_id, :integer
    add_column :assistance_requests, :original_activity_submission_id, :integer
  end
end
