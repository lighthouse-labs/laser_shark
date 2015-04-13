class UserMailer < ActionMailer::Base
  
  default from: ENV['EMAIL_SENDER']

  def new_activity_message(message)
    @message = message
    students = @message.cohort.students.active
    mail  subject: "#{@message.day.upcase} #{@message.kind}: #{@message.subject}", 
          to: ENV['INSTRUCTOR_EMAIL_GROUP'], 
          bcc: students.pluck(:email)
  end
  
end
