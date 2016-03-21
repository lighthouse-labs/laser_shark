class Skill < ActiveRecord::Base

  belongs_to :outcome
  
  # has_many :outcome_skills, dependent: :destroy
  # has_many :outcomes  , through: :outcome_skills

  validates :text, uniqueness: {case_sensitive: false}

  scope :search, -> (query) { where("lower(text) LIKE :query", query: "%#{query.downcase}%") }

end
