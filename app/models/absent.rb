class Absent < ActiveRecord::Base
  belongs_to :student, foreign_key: :user_id
end
