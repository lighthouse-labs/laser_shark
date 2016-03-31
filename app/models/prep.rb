class Prep < Section 

  def self.evaluate_rating(user_activity_outcome)
    submission_num = user_activity_outcome.user.activity_submissions.where(activity: user_activity_outcome.activity_outcome.activity).count
    (1 / submission_num * 3).to_i
  end

end