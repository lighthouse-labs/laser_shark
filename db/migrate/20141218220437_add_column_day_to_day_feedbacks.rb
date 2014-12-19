class AddColumnDayToDayFeedbacks < ActiveRecord::Migration
  def change
    add_column :day_feedbacks, :day, :string
  end
end
