class AddTeacherEmailGroupToCohorts < ActiveRecord::Migration
  def change
    add_column :cohorts, :teacher_email_group, :string
  end
end
