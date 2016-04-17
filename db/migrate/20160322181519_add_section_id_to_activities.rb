class AddSectionIdToActivities < ActiveRecord::Migration
  def change
    add_reference :activities, :section
  end
end
