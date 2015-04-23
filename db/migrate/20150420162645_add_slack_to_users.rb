class AddSlackToUsers < ActiveRecord::Migration
  def change
    add_column :users, :slack, :string
  end
end
