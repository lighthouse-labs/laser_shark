class Skill < ActiveRecord::Base
  belongs_to :category
  has_many :outcomes
end
