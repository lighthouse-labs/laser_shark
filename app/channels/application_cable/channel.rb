# app/channels/application_cable/channel.rb
module ApplicationCable
  class Channel < ActionCable::Channel::Base

    def update_students_in_queue(location)
      Student.has_open_requests.cohort_in_locations([location]).each do |student|
        UserChannel.broadcast_to student, {type: "QueueUpdate", object: student.position_in_queue.as_json}
      end
    end

  end
end