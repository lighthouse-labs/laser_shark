class NotificationMailer < ActionMailer::Base
  default :from => "hello@compass.lighthouselabs.ca"

  def confirmation_mailer(user)
    @user = user
    mail(:to => @user.email, :subject => "Welcome to Compass")
  end
end