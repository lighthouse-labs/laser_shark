class AddRemoteToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remote, :boolean, default: false
  end
end
