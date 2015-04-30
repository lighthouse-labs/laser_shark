class AddProgramToRecording < ActiveRecord::Migration
  def change
    add_column :recordings, :program_id, :integer
  end
end
