class RenameAverageRating < ActiveRecord::Migration
  def change
    rename_column :feedbacks, :average_rating, :rating
  end
end
