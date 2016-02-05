class AdminMailer < ActionMailer::Base
  
  default from: ENV['EMAIL_SENDER'], to: ENV['SUPER_ADMIN_EMAIL']

  def new_teacher_joined(teacher)
    @teacher = teacher
    @host = ENV['HOST']
    mail subject: 'New Teacher Joined'
  end

  def new_day_feedback(feedback, admin_emails)
    @feedback = feedback
    @host = ENV['HOST']
    mail subject: "Student Feedback (#{feedback.day}) [\##{feedback.id}]", reply_to: feedback.student.email, bcc: admin_emails
  end

end
