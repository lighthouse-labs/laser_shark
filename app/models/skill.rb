class Skill < ActiveRecord::Base
  belongs_to :category
  has_many :outcomes

  def my_parent
    category
  end

  def self.my_parent_name
    'category'
  end

  def children
    outcomes
  end

  def self.child_name
    'outcome'
  end
end
