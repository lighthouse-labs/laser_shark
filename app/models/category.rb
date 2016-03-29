class Category < ActiveRecord::Base

  has_many :outcomes, dependent: :destroy
  validates :text, uniqueness: {case_sensitive: false}

end
