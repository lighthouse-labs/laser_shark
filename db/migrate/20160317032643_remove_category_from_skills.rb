class RemoveCategoryFromSkills < ActiveRecord::Migration
  def change
    remove_column :skills, :category_id
  end
end
