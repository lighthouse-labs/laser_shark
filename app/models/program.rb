class Program < ActiveRecord::Base

  has_many :cohorts
  has_many :recordings
  # has_many :activities
  
  validates :name, presence: true

end
