class CreateLocations< ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.timestamps
    end

    add_column :users, :location_id, :integer
  end
end
