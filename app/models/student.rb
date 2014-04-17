class Student < ActiveRecord::Base

  belongs_to :cohort
  validates :uid,   presence: true
  validates :token, presence: true

  class << self
    def authenticate_via_github(auth)
      puts "Token is #{auth['credentials']['token']}"
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

end
