class AddInstructionsToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :instructions, :text
  end
end
