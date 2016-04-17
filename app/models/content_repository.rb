class ContentRepository < ActiveRecord::Base

  has_many :activities

  def to_s
    full_name
  end

  def full_name
    "#{github_username}/#{github_repo}"
  end
  
end
