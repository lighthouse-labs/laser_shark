class AddMediaFilenameToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :media_filename, :string
  end
end
