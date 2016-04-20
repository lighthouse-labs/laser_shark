class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.string :uuid

      t.timestamps null: false
    end
  end
end
