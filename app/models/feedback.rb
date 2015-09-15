class Feedback < ActiveRecord::Base
  belongs_to :reviewed, polymorphic: true
  belongs_to :student
  belongs_to :teacher
end
