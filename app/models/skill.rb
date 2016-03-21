class Skill < ActiveRecord::Base

  belongs_to :outcome
  validates :text, uniqueness: {case_sensitive: false}
  scope :search, -> (query) { where("lower(text) LIKE :query", query: "%#{query.downcase}%") }

end
