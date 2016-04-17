class AddOutcomeToSkills < ActiveRecord::Migration
  def change
    add_column :skills, :outcome_id, :integer
  end
end
