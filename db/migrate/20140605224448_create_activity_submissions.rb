class CreateActivitySubmissions < ActiveRecord::Migration
  def change
    create_table :activity_submissions do |t|
      t.references :user, index: true
      t.references :activity, index: true
      t.datetime :completed_at
    end
  end
end
