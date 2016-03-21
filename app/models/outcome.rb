class Outcome < ActiveRecord::Base

  belongs_to :category
  has_many :skills
  has_many :activity_outcomes, dependent: :destroy
  has_many :activities, through: :activity_outcomes
  # has_many :outcome_skills, dependent: :destroy
  # has_many :skills, through: :outcome_skills
  
  accepts_nested_attributes_for :skills, allow_destroy: true

  validates :text, uniqueness: {case_sensitive: false}
  
end
