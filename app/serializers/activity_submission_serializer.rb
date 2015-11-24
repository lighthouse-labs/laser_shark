class ActivitySubmissionSerializer < ActiveModel::Serializer
  
  attributes :github_url

  has_one :activity

end