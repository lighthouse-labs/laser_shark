class AddStudentNotesToAssistances < ActiveRecord::Migration
  def change
    add_column :assistances, :student_notes, :text
  end
end
