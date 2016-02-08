class Skill < ActiveRecord::Base
  belongs_to :category
  has_many :outcomes, dependent: :destroy

  validates :text, uniqueness: {case_sensitive: false}
end
