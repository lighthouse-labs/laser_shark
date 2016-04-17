class Section < ActiveRecord::Base
  has_many :activities

  validates :slug, presence: true, uniqueness: true

  def to_param
    self.slug
  end
end
