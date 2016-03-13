class AddTestsToActivities < ActiveRecord::Migration
  def change
    create_table :activity_tests do |t|
      t.text :test
      t.integer :activity_id
    end
  end
end
