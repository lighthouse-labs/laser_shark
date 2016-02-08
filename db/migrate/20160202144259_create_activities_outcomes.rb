class CreateActivitiesOutcomes < ActiveRecord::Migration
  def change
    create_table :activities_outcomes do |t|

      t.timestamps null: false
    end
  end
end
