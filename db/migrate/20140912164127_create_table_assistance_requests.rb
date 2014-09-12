class CreateTableAssistanceRequests < ActiveRecord::Migration
  def change
    create_table :assistance_requests do |t|
      t.integer :requestor_id
      t.integer :assistor_id

      t.datetime :request_start_at
      t.datetime :assistance_start_at
      t.datetime :assistance_end_at

      t.timestamps
    end
  end
end
