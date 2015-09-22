class Feedback < ActiveRecord::Base
  belongs_to :feedbackable, polymorphic: true
  belongs_to :student
  belongs_to :teacher

  scope :completed, -> { where("technical_rating IS NOT NULL AND style_rating IS NOT NULL") }
  scope :pending, -> { where("technical_rating IS NULL OR style_rating IS NULL") }
  scope :reverse_chronological_order, -> {order("created_at DESC")}

  validates :technical_rating, presence: true, on: :update 
  validates :style_rating, presence: true, on: :update

end
