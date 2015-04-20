class AddReasonToAssistanceRequests < ActiveRecord::Migration
  def change
    add_column :assistance_requests, :reason, :string
  end
end
