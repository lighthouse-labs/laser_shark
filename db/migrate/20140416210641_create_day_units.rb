class CreateDayUnits < ActiveRecord::Migration
  def change
    create_table :day_units do |t|
      t.string :name
      t.integer :day
      t.integer :start_time
      t.integer :duration

      t.timestamps
    end
  end
end
