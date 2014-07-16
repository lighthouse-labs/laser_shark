class ActivitiesAddTeacherNotesGistUrl < ActiveRecord::Migration
  def change
    add_column :activities, :teacher_notes_gist_url, :string
  end
end
