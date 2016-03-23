class Outcome < ActiveRecord::Base

  belongs_to :category
  has_many :skills, dependent: :destroy
  has_many :activity_outcomes, dependent: :destroy
  has_many :activities, through: :activity_outcomes
  
  accepts_nested_attributes_for :skills, allow_destroy: true

  validates :text, uniqueness: {case_sensitive: false}

  scope :search, -> (query) { where("lower(text) LIKE :query", query: "%#{query.downcase}%") }
  
end
