class UserSerializer < ActiveModel::Serializer

  root false

  attributes :id,
    :type,
    :email,
    :first_name, 
    :last_name,
    :github_username

  has_one :location

end
