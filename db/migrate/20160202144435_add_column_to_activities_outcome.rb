class AddColumnToActivitiesOutcome < ActiveRecord::Migration
  def change
    add_column :activities_outcomes, :outcome_id, :integer
    add_column :activities_outcomes, :activity_id, :integer
  end
end
