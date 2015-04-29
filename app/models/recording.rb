class Recording < ActiveRecord::Base

  belongs_to :presenter, :class => User
  belongs_to :cohort
  belongs_to :activity

end
