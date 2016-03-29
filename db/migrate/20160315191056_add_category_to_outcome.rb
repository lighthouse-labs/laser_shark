class AddCategoryToOutcome < ActiveRecord::Migration
  def change
    add_column :outcomes, :category_id, :integer
    remove_column :outcomes, :skill_id
  end
end
