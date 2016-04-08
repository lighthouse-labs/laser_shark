class ChangeOutcomesColumns < ActiveRecord::Migration
  def change
    remove_column :outcomes, :category_id, :integer
    add_column :skills, :category_id, :integer
    add_index :skills, :category_id

    remove_column :skills, :outcome_id, :integer
    add_column :outcomes, :skill_id, :integer
    add_index :outcomes, :skill_id

    rename_column :categories, :text, :name
    rename_column :skills, :text, :name
  end
end
