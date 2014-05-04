class AddGistUrlToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :gist_url, :string
  end
end
