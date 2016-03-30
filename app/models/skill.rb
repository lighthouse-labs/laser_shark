class Skill < ActiveRecord::Base

  belongs_to :category
  has_many :outcomes, :dependent => :destroy

  accepts_nested_attributes_for :outcomes, reject_if: Proc.new { |outcome| outcome[:text].blank? }, allow_destroy: true
  
  validates :name, uniqueness: {case_sensitive: false}
  
  scope :search, -> (query) { where("lower(name) LIKE :query", query: "%#{query.downcase}%") }

end
