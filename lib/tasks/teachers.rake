def format_channel_name(channel, id='')
  s = [ENV['APP_NAME'], channel, id.to_s].join('-')
end

namespace :teachers do
  desc "Log all teachers out"
  task on_duty_reset: :environment do
    Teacher.where(on_duty: true).each do |teacher|
      teacher.update(on_duty: false)

      Pusher.trigger format_channel_name("TeacherChannel"),
                     'received', {
                        type: "TeacherOffDuty",
                        object: UserSerializer.new(teacher).as_json
                     }
    end
  end
end