class AddReceiveFeedbackEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :receive_feedback_emails, :boolean, default: false
  end
end
