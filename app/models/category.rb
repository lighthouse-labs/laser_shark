class Category < ActiveRecord::Base
  has_many :skills, dependent: :destroy

  validates :text, uniqueness: {case_sensitive: false}
end
