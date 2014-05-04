class ExistingUsersAsStudents < ActiveRecord::Migration
  def change
    User.update_all type: 'Student'
  end
end
