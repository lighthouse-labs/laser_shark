class AddTeachersNotesToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :teacher_notes, :text
  end
end
