class CreateOutcomeResults < ActiveRecord::Migration
  def change
    create_table :outcome_results do |t|
      t.references :user, index: true, foreign_key: true
      t.references :outcome, index: true, foreign_key: true
      
      t.string :source_name
      t.references :source, polymorphic: true, index: true
      t.float :rating

      t.timestamps null: false
    end
  end
end
