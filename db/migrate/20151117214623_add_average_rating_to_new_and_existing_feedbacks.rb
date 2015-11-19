class AddAverageRatingToNewAndExistingFeedbacks < ActiveRecord::Migration
  def change
    add_column :feedbacks, :average_rating, :float
    Feedback.all.each do |feedback|
      if feedback.technical_rating && feedback.style_rating
        feedback.average_rating = (feedback.technical_rating.to_f + feedback.style_rating.to_f)/2
        feedback.save
      end
    end
  end
end
