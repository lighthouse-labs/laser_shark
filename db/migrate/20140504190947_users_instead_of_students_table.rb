class UsersInsteadOfStudentsTable < ActiveRecord::Migration
  def up
    add_column :students, :type, :string
    rename_table :students, :users
  end

  def down
    remove_column :users, :type
    rename_table :students, :users
  end
end
