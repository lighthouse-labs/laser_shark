class ActivitySubmissionSerializer < ActiveModel::Serializer
  
  attributes :github_url, :data, :finalized
  has_one :activity

end