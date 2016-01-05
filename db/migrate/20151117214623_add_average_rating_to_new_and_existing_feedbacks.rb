class AddAverageRatingToNewAndExistingFeedbacks < ActiveRecord::Migration
  def change
    add_column :feedbacks, :average_rating, :float
    Feedback.find_each(batch_size: 200).each do |feedback|
      if feedback.technical_rating && feedback.style_rating
        avg = (feedback.technical_rating.to_f + feedback.style_rating.to_f)/2
        Feedback.where(id: feedback.id).update_all(average_rating: avg)
      end
    end
  end
end
