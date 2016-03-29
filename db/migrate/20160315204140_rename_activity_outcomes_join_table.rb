class RenameActivityOutcomesJoinTable < ActiveRecord::Migration
  def change
    rename_table :activities_outcomes, :activity_outcomes
  end
end
