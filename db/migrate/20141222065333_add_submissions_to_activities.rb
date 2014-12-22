class AddSubmissionsToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :allow_submissions, :boolean, default: true
  end
end
