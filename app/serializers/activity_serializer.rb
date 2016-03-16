class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :day, :name, :type, :value

  def value
    (object.name + ' ' + object.day rescue object.name)
  end
end