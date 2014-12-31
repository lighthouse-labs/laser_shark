class Video < Activity
  
  validates :media_filename, presence: true

  default_value_for :allow_submissions, false

  HOST = "http://d10ofk0qhbh8u9.cloudfront.net/screencasts/"

end
