class Category < ActiveRecord::Base
  has_many :skills

  def my_parent
    nil
  end

  def self.my_parent_name
    'category'
  end

  def children
    skills
  end

  def self.child_name
    'skill'
  end

end
