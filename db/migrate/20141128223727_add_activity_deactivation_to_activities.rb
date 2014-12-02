class AddActivityDeactivationToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :deactivate_activity, :boolean, default: false
  end
end
