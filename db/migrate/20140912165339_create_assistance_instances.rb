class CreateAssistanceInstances < ActiveRecord::Migration
  def change
    create_table :assistances do |t|
      t.integer :assistor_id

      t.datetime :start_at
      t.datetime :end_at

      t.text :notes

      t.timestamps
    end

    # remove_column :assistance_requests, :assistor_id
    # remove_column :assistance_requests, :assistance_start_at
    # remove_column :assistance_requests, :assistance_end_at
  end
end
