class Teacher < User

  has_many :feedbacks

  has_many :teaching_assistances, class_name: Assistance, foreign_key: :assistor_id

  scope :filter_by_location, -> (location_id) {
    includes(:location).
    where(locations: {id: location_id})
  }

  scope :filter_by_teacher, -> (teacher_id) {
    where(id: teacher_id)
  }

  validates :bio,             presence: true, length: { maximum: 1000 }
  validates :quirky_fact,     presence: true
  validates :specialties,     presence: true

  def self.filter_by(options)
    options.inject(all) do |result, (k, v)|
      attribute = k.gsub("_id", "")
      result = result.send("filter_by_#{attribute}", v)
    end
  end

  def can_access_day?(day)
    true
  end

  def prepping?
    false
  end

  def prospect?
    false
  end

  def busy?
    self.teaching_assistances.currently_active.length > 0
  end

  def send_web_socket_available
    Pusher.trigger(
      SocketService.get_formatted_channel_name('TeacherChannel'),
      'received', {
        type: "TeacherAvailable",
        object: UserSerializer.new(self).as_json
      }
    )
  end

  def send_web_socket_busy
    Pusher.trigger(
      SocketService.get_formatted_channel_name('TeacherChannel'),
      'received', {
        type: "TeacherBusy",
        object: UserSerializer.new(self).as_json
      }
    )
  end


end
