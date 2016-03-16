class Outcome < ActiveRecord::Base

  has_many :activity_outcomes, dependent: :destroy
  has_many :activities, through: :activity_outcomes

  has_many :outcome_skills, dependent: :destroy
  has_many :skills, through: :outcome_skills

  belongs_to :category
  # has_many: skills

  validates :text, uniqueness: {case_sensitive: false}
  
end
