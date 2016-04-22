class Answer < ActiveRecord::Base

  belongs_to :option

  belongs_to :quiz_submission
end
