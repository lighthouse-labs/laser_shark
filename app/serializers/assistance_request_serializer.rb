class AssistanceRequestSerializer < ActiveModel::Serializer

  root false

  attributes :id, :reason, :start_at

  has_one :activity_submission
  has_one :requestor, serializer: UserSerializer

end