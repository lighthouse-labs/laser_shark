class AddUnlockedUntilDayToUsers < ActiveRecord::Migration
  def change
    add_column :users, :unlocked_until_day, :string
  end
end
