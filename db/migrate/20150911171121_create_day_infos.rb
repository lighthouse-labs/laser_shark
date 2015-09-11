class CreateDayInfos < ActiveRecord::Migration
  def change
    create_table :day_infos do |t|
      t.string :day
      t.text :description

      t.timestamps
    end
  end
end
