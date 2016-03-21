class ActivitySerializer < ActiveModel::Serializer

  root false
  
  attributes :id, :day, :name, :type, :value

  def value
    (object.name + ' ' + object.day rescue object.name)
  end
end