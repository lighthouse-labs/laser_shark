class Student < User

  belongs_to :cohort
  has_many :day_feedbacks, foreign_key: :user_id
  has_many :feedbacks
  
  scope :in_active_cohort, -> { joins(:cohort).merge(Cohort.is_active) }
  scope :has_open_requests, -> {
    joins(:assistance_requests).
    where(assistance_requests: {type: nil, canceled_at: nil, assistance_id: nil}).
    references(:assistance_requests)
  }

  def self.send_queue_update_in_location(location)
    Student.has_open_requests.cohort_in_locations([location]).each do |student|
      Pusher.trigger(
        SocketService.get_formatted_channel_name("UserChannel", student.id),
        "received", {
          type: "QueueUpdate",
          object: student.position_in_queue.as_json
        }
      )
    end
  end

  def prepping?
    self.cohort.nil?
  end

  def prospect?
    false
  end

  def active_student?
    !prepping? && cohort.active?
  end

  def alumni?
    !prepping? && cohort.finished?
  end



end
