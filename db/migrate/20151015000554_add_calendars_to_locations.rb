class AddCalendarsToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :calendar, :string
  end
end
