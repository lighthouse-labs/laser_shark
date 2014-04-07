class AddCompletedRegistrationToStudents < ActiveRecord::Migration
  def change
    add_column :students, :completed_registration, :boolean
  end
end
