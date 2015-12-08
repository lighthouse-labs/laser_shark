class AddNotesToDayFeedback < ActiveRecord::Migration
  def change
    add_column :day_feedbacks, :notes, :text
  end
end
