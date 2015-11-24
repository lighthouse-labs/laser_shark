class AssistanceSerializer < ActiveModel::Serializer

  root false
  
  attributes :id, :start_at
  has_one :assistance_request, serializer: AssistanceRequestSerializer
  has_one :assistor, serializer: UserSerializer
  has_one :assistee, serializer: UserSerializer

end