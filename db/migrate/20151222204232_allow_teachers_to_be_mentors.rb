class AllowTeachersToBeMentors < ActiveRecord::Migration
  def change
    add_column :users, :mentor, :boolean, :default => false
  end
end
