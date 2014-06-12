class AddCustomAvatarToUsers < ActiveRecord::Migration
  def change
    add_column :users, :custom_avatar, :string
  end
end
