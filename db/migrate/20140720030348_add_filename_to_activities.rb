class AddFilenameToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :file_name, :string
  end
end
