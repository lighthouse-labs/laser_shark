class CreateDayFeedbacks < ActiveRecord::Migration
  def change
    create_table :day_feedbacks do |t|
      t.string :mood
      t.string :title
      t.text :text
      t.integer :user_id
      t.timestamps
    end
  end
end
