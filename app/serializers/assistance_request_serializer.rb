class AssistanceRequestSerializer < ActiveModel::Serializer

  attributes :id, :reason, :start_at

  has_one :activity_submission
  has_one :requestor, serializer: UserSerializer

end