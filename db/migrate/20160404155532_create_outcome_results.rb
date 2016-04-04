class CreateOutcomeResults < ActiveRecord::Migration
  def change
    create_table :outcome_results do |t|
      t.references :user, index: true, foreign_key: true
      t.references :outcome, index: true, foreign_key: true
      
      t.string :source
      t.references :resultable, polymorphic: true, index: true
      t.float :rating

      t.timestamps null: false
    end
  end
end
