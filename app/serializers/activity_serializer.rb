class ActivitySerializer < ActiveModel::Serializer

  root false
  
  attributes :id, :day, :name, :type

end