class Program < ActiveRecord::Base

  has_many :cohorts
  has_many :recordings
  
  validates :name, presence: true

  serialize :tags

end
