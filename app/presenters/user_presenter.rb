class UserPresenter < BasePresenter
  presents :user

  def image_for_index_page
    h.image_tag(avatar_for, size: '100x100')
  end

  def image_for_show_page
    h.image_tag(avatar_for, size: '200x200')
  end

  def full_name
    user.full_name
  end

  def email
    user.email
  end

  def phone_number
    user.phone_number
  end

  def quirky_fact
    user.quirky_fact
  end

  def bio
    user.bio
  end

  def specialties
    user.specialties
  end

  def company?
    user.company_name.present? && user.company_url.present?
  end

  def github_username?
    user.github_username.present?
  end

  def twitter?
    user.twitter.present?
  end

  def slack?
    user.slack.present?
  end

  def skype?
    user.skype.present?
  end

  def company_name
    user.company_name
  end

  def company_url
    user.company_url
  end

  def linked_company
    link_to user.company_name, "http://#{user.company_url}", target: "_blank"
  end

  def linked_github_image
    link_to image_tag('github-icon.png'), "https://github.com/#{user.github_username}", target: "_blank"
  end

  def linked_github_username
    link_to user.github_username, "https://github.com/#{user.github_username}", target: "_blank"
  end

  def linked_twitter_image
    link_to image_tag('twitter-icon.png'), "https://twitter.com/#{user.twitter}", target: "_blank"
  end

  def linked_twitter
    link_to user.twitter, "https://twitter.com/#{user.twitter}", target: "_blank"
  end

  def slack_image
    image_tag('slack-icon.png')
  end

  def slack
    user.slack
  end

  def skype_image
    image_tag('skype-icon.png')
  end

  def skype
    user.skype
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