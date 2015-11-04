class UserPresenter < BasePresenter
  presents :user

  delegate :full_name, :email, :phone_number, :quirky_fact, :bio, :specialties, :company_name, :company_url, :slack, :skype, to: :user

  def image_for_index_page
    h.image_tag(avatar_for, size: '100x100')
  end

  def image_for_show_page
    h.image_tag(avatar_for, size: '200x200')
  end
  
  def github_info
    if user.github_username.present?
      content_tag :li do
        link_to "https://github.com/#{user.github_username}", target: "_blank" do
          github_image + " " + user.github_username
        end
      end
    end
  end

  def twitter_info
    if user.twitter.present?
      content_tag :li do
        link_to "https://twitter.com/#{user.twitter}", target: "_blank" do
          twitter_image + " " + user.twitter
        end
      end
    end
  end

  def slack_info
    if user.slack.present?
      content_tag :li do
        slack_image + " " + user.slack  
      end
    end
  end

  def skype_info
    if user.skype.present?
      content_tag :li do
        skype_image + " " + user.skype
      end
    end
  end
  
  private

  def avatar_for
    if user.custom_avatar.url
      user.custom_avatar.url(:thumb)
    else
      user.avatar_url
    end
  end

  def github_image
    image_tag('github-icon.png')
  end

  def twitter_image
    image_tag('twitter-icon.png')
  end

  def slack_image
    image_tag('slack-icon.png')
  end

  def skype_image
    image_tag('skype-icon.png')
  end


end