class CodeReviewSerializer < ActiveModel::Serializer

  root false

  attributes :id, :start_at

  has_one :requestor, serializer: UserSerializer
  has_one :activity
end
