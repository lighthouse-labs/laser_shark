class AddRemoteContentToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :remote_content, :boolean
  end
end
