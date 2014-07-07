class User < ActiveRecord::Base

  belongs_to :cohort

  validates :uid,   presence: true
  validates :token, presence: true

  mount_uploader :custom_avatar, CustomAvatarUploader

  def prepping?
    true
  end

  def can_access_day?(day)
    return true if day == 'w1d1'
    return false unless cohort

    today = CurriculumDay.new(Time.zone.now.to_date, cohort).to_s
    if day <= today
      true
    else
      false
    end
  end

  class << self
    def authenticate_via_github(auth)
      where(uid: auth["uid"]).first_or_create(attributes_from_oauth(auth))
    end

    private

    def attributes_from_oauth(auth)
      {
        token: auth["credentials"]["token"],
        github_username: auth["info"]["nickname"],
        first_name: auth["info"]["name"].to_s.split.first,
        last_name: auth["info"]["name"].to_s.split.last,
        avatar_url: auth["info"]["image"],
        email: auth["info"]["email"]
      }
    end
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

end
