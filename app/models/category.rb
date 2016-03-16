class Category < ActiveRecord::Base
  has_many :skills, dependent: :destroy
  has_many :outcomes

  validates :text, uniqueness: {case_sensitive: false}
end
