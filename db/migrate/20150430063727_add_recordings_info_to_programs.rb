class AddRecordingsInfoToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :recordings_folder, :string
    add_column :programs, :recordings_bucket, :string
  end
end
