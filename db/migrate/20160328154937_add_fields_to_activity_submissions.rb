class AddFieldsToActivitySubmissions < ActiveRecord::Migration
  def change
    add_column :activity_submissions, :finalized, :boolean, default: false
    add_column :activity_submissions, :data, :text
  end
end
