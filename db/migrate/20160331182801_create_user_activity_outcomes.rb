class CreateUserActivityOutcomes < ActiveRecord::Migration
  def change
    create_table :user_activity_outcomes do |t|
      t.references :user, index: true, foreign_key: true
      t.references :activity_outcome, index: true, foreign_key: true
      t.float :rating

      t.timestamps null: false
    end
  end
end
