class AdminCanArchiveDayfeedbacks < ActiveRecord::Migration
  def change
    add_column :day_feedbacks, :archived_at, :datetime
    add_column :day_feedbacks, :archived_by_user_id, :integer
  end
end
