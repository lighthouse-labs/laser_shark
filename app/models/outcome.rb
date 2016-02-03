class Outcome < ActiveRecord::Base
  has_many :activities_outcomes
  has_many :activities, through: :activities_outcomes
  belongs_to :skill

  def my_parent
    skill
  end

  def self.parental_name
    "skill"
  end

  def children
    activities
  end

  def self.child_name
    'activity'
  end
end
