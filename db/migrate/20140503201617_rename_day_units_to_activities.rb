class RenameDayUnitsToActivities < ActiveRecord::Migration

  def change
    drop_table :day_units

    create_table "activities" do |t|
      t.string   "name"
      t.integer  "day", index: true
      t.integer  "start_time", index: true
      t.integer  "duration"
      t.timestamps
    end

  end
end
