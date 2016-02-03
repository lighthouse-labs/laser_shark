class Category < ActiveRecord::Base
  has_many :skills

  def my_parent
    no_parent
  end

  def self.parental_name
    'category'
  end

  def children
    skills
  end

  def self.child_name
    'skill'
  end

  def no_parent
    self
  end
end
