class UserPresenter < BasePresenter
  presents :user

  delegate :full_name, :email, :phone_number, :quirky_fact, :bio, :specialties, :company_name, :company_url, :slack, :skype, :type, to: :user

  def image_for_index_page
    avatar_of_side_length(100)
  end

  def image_for_show_page
    avatar_of_side_length(230)
  end

  def avatar_of_side_length(side_length)
    h.image_tag(avatar_for, size: "#{side_length}x#{side_length}")
  end

  ## Clean up social media methods
  
  def github_info
    if user.github_username.present?
      if user.type == 'Teacher'
        content_tag :li do
          link_to "https://github.com/#{user.github_username}", target: "_blank" do
            image_tag('github-icon.png') + " " + user.github_username
          end
        end
      else
        link_to "https://github.com/#{user.github_username}", target: "_blank" do
          image_tag('github-icon.png') + " " + user.github_username
        end
      end
    end
  end

  def twitter_info 
    twitter_link
  end

  def slack_info
    if user.slack.present?
      if user.type == 'Teacher'
        content_tag :li do
          image_tag('slack-icon.png') + " " + user.slack  
        end
      else
        image_tag('slack-icon.png') + " " + user.slack  
      end
    end
  end

  def skype_info
    if user.skype.present?
      if user.type == 'Teacher'
        content_tag :li do
          image_tag('skype-icon.png') + " " + user.skype
        end
      else
        image_tag('skype-icon.png') + " " + user.skype
      end
    end
  end

  def twitter_link
    return unless user.twitter.present?
    link_to "https://twitter.com/#{user.twitter}", target: "_blank" do
      image_tag('twitter-icon.png') + " " + user.twitter
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

end