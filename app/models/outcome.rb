class Outcome < ActiveRecord::Base

  belongs_to :skill
  
  has_many :item_outcomes, dependent: :destroy
  has_many :activities, through: :item_outcomes, source: :item, source_type: 'Activity'

  accepts_nested_attributes_for :item_outcomes, reject_if: Proc.new { |ao| ao[:item_type].blank? }, allow_destroy: true
  
  validates :text, uniqueness: {case_sensitive: false}

  scope :search, -> (query) { where("lower(text) LIKE :query", query: "%#{query.downcase}%") }
  
end
