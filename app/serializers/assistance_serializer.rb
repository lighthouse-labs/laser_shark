class AssistanceSerializer < ActiveModel::Serializer
  
  attributes :id, :start_at
  has_one :assistance_request
  has_one :assistor, serializer: UserSerializer
  has_one :assistee, serializer: UserSerializer

end