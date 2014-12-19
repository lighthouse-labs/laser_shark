class DayFeedback < ActiveRecord::Base
	belongs_to :user, class_name: "Student", foreign_key: :user_id
  validates :title, presence: true
  validates :text, presence: true
  validates :day, presence: true
end
