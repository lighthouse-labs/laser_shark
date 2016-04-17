class ChangeActivityOutcomesTableName < ActiveRecord::Migration
  def change
    rename_table :activity_outcomes, :item_outcomes
    remove_column :item_outcomes, :activity_id
    add_column :item_outcomes, :item_type, :string
    add_column :item_outcomes, :item_id, :integer
    add_index :item_outcomes, :item_id

    ItemOutcome.destroy_all
  end
end
