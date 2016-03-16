class Skill < ActiveRecord::Base

  belongs_to :category
  
  has_many :outcome_skills, dependent: :destroy
  has_many :outcomes  , through: :outcome_skills

  validates :text, uniqueness: {case_sensitive: false}

end
