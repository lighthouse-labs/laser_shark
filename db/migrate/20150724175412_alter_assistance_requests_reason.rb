class AlterAssistanceRequestsReason < ActiveRecord::Migration
  def change
    change_column :assistance_requests, :reason, :text
  end
end
