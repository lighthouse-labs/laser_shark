class Outcome < ActiveRecord::Base
  has_many :activities_outcomes, dependent: :destroy
  has_many :activities, through: :activities_outcomes
  belongs_to :skill

  validates :text, uniqueness: {case_sensitive: false}
end
