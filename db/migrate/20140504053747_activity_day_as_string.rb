class ActivityDayAsString < ActiveRecord::Migration
  def up
    remove_column :activities, :day
    add_column :activities, :day, :string
  end
  def down
    remove_column :activities, :day
    add_column :activities, :day, :integer
  end
end
