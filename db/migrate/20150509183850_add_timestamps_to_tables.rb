class AddTimestampsToTables < ActiveRecord::Migration
  def change
    add_column :users, :created_at, :datetime
    add_column :users, :updated_at, :datetime

    add_column :activity_submissions, :created_at, :datetime
    add_column :activity_submissions, :updated_at, :datetime
  end
end
