class AddCanceledToAssistanceRequests < ActiveRecord::Migration
  def change
    add_column :assistance_requests, :canceled_at, :datetime
  end
end
