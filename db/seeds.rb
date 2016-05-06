# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) can be set in the file .env file.

if Rails.env.development?
  # make some setup tasks
  DayInfo.create!(day: "setup")
  Assignment.create!({
    name: "What eva",
    day: "setup",
    start_time: 900,
    duration: rand(20..60),
    instructions: Faker::Lorem.paragraphs.join("<br/><br/>")
  })
  # => Create activities and content for cohort
  assignments = []
  1.upto(8).each do |week|
    1.upto(5).each do |day|

      day = "w#{week}d#{day}"

      DayInfo.create!(day: day)

      [900, 1100, 1500, 1900, 2200].each do |time|
        params = {
          name: Faker::Commerce.product_name,
          day: day,
          start_time: time,
          duration: rand(60..180),
          instructions: Faker::Lorem.paragraphs.join("<br/><br/>")
        }

        if time == 900
          params[:allow_submissions] = false
          Lecture.create!(params)
        else
          assignments << Assignment.create!(params)
        end

      end
    end
  end

  Cohort.destroy_all

  program = Program.create(name: "Web Immersive")
  locations = [Location.create(name: "Vancouver"), Location.create(name: "Toronto")]
  cohorts = [
    Cohort.create!(name: "Current Cohort Van", code: "current van", location: locations[0], start_date: Date.today - 7.days, program: program, code: "van"),
    Cohort.create!(name: "Current Cohort Tor", code: "current tor", location: locations[1], start_date: Date.today - 14.days, program: program, code: "toto")
  ]

  @teachers = []
  10.times do |x|
    @teachers << Teacher.create!(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      uid: 1000 + x,
      token: 2000 + x,
      completed_registration: true,
      company_name: Faker::Company.name,
      bio: Faker::Lorem.sentence,
      specialties: Faker::Lorem.sentence,
      quirky_fact: Faker::Lorem.sentence,
      phone_number: Faker::PhoneNumber.phone_number,
      github_username: Faker::Internet.user_name,
      location: locations.sample,
    )
  end

  cohorts.each do |cohort|
    10.times do |i|
      student = Student.create!(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.email,
        cohort: cohort,
        phone_number: Faker::PhoneNumber.phone_number,
        github_username: Faker::Internet.user_name,
        location: cohort.location,
        uid: 1000 + i,
        token: 2000 + i,
        completed_registration: true
      )
      10.times do |y|
        teacher = @teachers.sample
        # create a sampled assistance request
        ar = AssistanceRequest.create!(
          requestor: student,
          assistor_id: teacher.id,
          start_at: Date.today - 10.minutes,
          assistance_start_at: Date.today - 10.minutes,
          assistance_end_at: Date.today - 8.minutes,
          type: nil,
          assistance: Assistance.create(
            assistor_id: teacher.id,
            assistee_id: student.id,
            start_at: Date.today - 10.minutes,
            end_at: Date.today - 8.minutes,
            notes: Faker::Lorem.sentence,
            rating: [1,2,3,4].sample
          ),
          reason: Faker::Lorem.sentence
        )
        # create a student feedback on this AssistanceRequest
        Feedback.create!(
          student_id: student.id,
          teacher_id: teacher.id,
          notes: Faker::Lorem.sentence,
          rating: [1,2,3,4].sample,
          feedbackable_id: ar.assistance.id,
          feedbackable_type: 'Assistance'
        )
      end # 10 loop for assistance

      # student submissions
      # HACK does not prevent duplicate submissions
      assignments.sample(10).each do |activity|
        ActivitySubmission.create!(
          user: student,
          github_url: Faker::Internet.url('github.com'),
          activity: activity
        )
      end
    end # 10 loop for students
  end # locations

end
