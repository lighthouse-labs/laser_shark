class CreateRecordings < ActiveRecord::Migration
  def change
    create_table :recordings do |t|
      t.string :file_name
      t.datetime :recorded_at
      t.integer :presenter_id
      t.integer :cohort_id
      t.integer :activity_id

      t.timestamps
    end
  end
end
