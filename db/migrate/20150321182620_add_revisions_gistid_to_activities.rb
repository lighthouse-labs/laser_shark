class AddRevisionsGistidToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :revisions_gistid, :string
  end
end
