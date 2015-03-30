class AdminMailer < ActionMailer::Base
  
  default from: ENV['EMAIL_SENDER'], to: ENV['SUPER_ADMIN_EMAIL']

  def new_teacher_joined(teacher)
    @teacher = teacher
    @host = ENV['HOST']
    mail subject: 'New Teacher Joined'
  end

end
