class AddLocationToCohorts < ActiveRecord::Migration
  def change
    add_column :cohorts, :location, :string, default: 'Vancouver'
  end
end
