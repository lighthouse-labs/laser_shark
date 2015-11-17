class AddFeedbackFlagToActivities < ActiveRecord::Migration
  def up
    add_column :activities, :allow_feedback, :boolean, :default => true
    Activity.where(type: 'Lecture').update_all(allow_feedback: false)
  end

  def down
    remove_column :activities, :allow_feedback
  end
end
