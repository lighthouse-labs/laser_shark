class RenameIsMentorFieldForTeachers < ActiveRecord::Migration
  def change
    rename_column :users, :mentor, :is_mentor
  end
end
