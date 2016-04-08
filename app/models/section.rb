class Section < ActiveRecord::Base
  has_many :activities

  def to_param
    self.slug
  end
end
