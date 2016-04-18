class CreateOutcomeSkillsTable < ActiveRecord::Migration
  def change
    create_table :outcome_skills do |t|
      t.integer :outcome_id
      t.integer :skill_id
    end
  end
end
