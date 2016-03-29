class AddSkillsIdToOutcome < ActiveRecord::Migration
  def change
    add_column :outcomes, :skill_id, :integer
  end
end
