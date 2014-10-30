class ChangeAssistanceRequests < ActiveRecord::Migration
  def change
    rename_column :assistance_requests, :request_start_at, :start_at
    add_column :assistance_requests, :assistance_id, :integer
  end
end
