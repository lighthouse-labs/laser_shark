class AddLastAssistedAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_assisted_at, :datetime
  end
end
