class AddContentRepositoryIdToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :content_repository_id, :integer
    add_index :activities, :content_repository_id
  end
end
