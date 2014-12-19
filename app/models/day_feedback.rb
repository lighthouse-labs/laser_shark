class DayFeedback < ActiveRecord::Base
	
  belongs_to :student, foreign_key: :user_id
  
  validates :title, presence: true
  validates :text,  presence: true
  validates :day,   presence: true
  validates :mood,  presence: true

end
