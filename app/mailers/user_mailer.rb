class UserMailer < ActionMailer::Base

  add_template_helper(ActivitiesHelper)
  
  default from: ENV['EMAIL_SENDER']

  def new_activity_message(message)
    @message = message
    students = @message.cohort.students.active
    mail  subject: "#{@message.day.upcase} #{@message.kind}: #{@message.subject}", 
          to: @message.cohort.teacher_email_group || ENV['INSTRUCTOR_EMAIL_GROUP'] || ENV['EMAIL_SENDER'], 
          bcc: students.pluck(:email)
  end
  
end
