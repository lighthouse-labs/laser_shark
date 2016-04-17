class AddContentFilePathToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :content_file_path, :string
  end
end
