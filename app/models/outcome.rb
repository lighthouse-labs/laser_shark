class Outcome < ActiveRecord::Base

  belongs_to :skill
  
  has_many :activity_outcomes, dependent: :destroy
  has_many :activities, through: :activity_outcomes
  
  validates :text, uniqueness: {case_sensitive: false}

  scope :search, -> (query) { where("lower(text) LIKE :query", query: "%#{query.downcase}%") }
  
end
