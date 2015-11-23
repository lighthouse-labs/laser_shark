class UserSerializer < ActiveModel::Serializer

  root false

  attributes :id,
    :type,
    :email,
    :first_name, 
    :last_name,
    :github_username,
    :avatar_url,
    :busy

  has_one :location
  has_one :cohort

  protected

  def avatar_url
    object.custom_avatar.url.try(:thumb) || object.avatar_url
  end

  def busy
    if object.is_a?(Teacher)
      object.teaching_assistances.currently_active.length > 0
    end
  end

end
