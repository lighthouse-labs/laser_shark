class UserPresenter
  presents :user

  def image
    h.image_tag(avatar_for, size: '200x200')
  end

  def full_name
    user.full_name
  end

  private

  def avatar_for
    if user.custom_avatar.url
      user.custom_avatar.url(:thumb)
    else
      user.avatar_url
    end
  end

end