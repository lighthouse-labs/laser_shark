class RenamePrepDayToSetupDay < ActiveRecord::Migration
  def up
    puts Activity.where(day: 'prep').update_all(day: 'setup').inspect
  end
  def down
    puts Activity.where(day: 'setup').update_all(day: 'prep').inspect
  end
end
