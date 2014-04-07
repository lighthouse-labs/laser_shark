class AddOAuthFieldsToStudents < ActiveRecord::Migration
  def change
    add_column :students, :uid, :string
    add_column :students, :token, :string
  end
end
