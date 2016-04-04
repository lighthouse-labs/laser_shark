class Option < ActiveRecord::Base
  belongs_to :question

  has_many :answers, dependent: :nullify

  def selected?(submission)
    submission.option_selected?(self)
  end
end
