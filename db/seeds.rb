# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) can be set in the file .env file.

if Rails.env.development?
  # => Create activities and content for cohort
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
          Lecture.create!(params)
        else
          Assignment.create!(params)
        end

      end
    end
  end

  Cohort.destroy_all

  program = Program.create(name: "Web Immersive")
  location_van = Location.create(name: "Vancouver")
  location_to = Location.create(name: "Toronto")
  cohort_van = Cohort.create! name: "Current Cohort Van", code: "current van", location: location_van, start_date: Date.today - 7.days, program: program, code: "van"
  cohort_tor = Cohort.create! name: "Current Cohort Tor", code: "current tor", location: location_to, start_date: Date.today - 14.days, program: program, code: "toto"

  10.times do |i|
    Student.create!(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      cohort: cohort_van,
      phone_number: '123-123-1234',
      github_username: 'useruser',
      location: location_van,
      uid: 1000 + i,
      token: 2000 + i,
      completed_registration: true
    )
  end

  10.times do |x|
    Teacher.create!(
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
      phone_number: '123-123-1234',
      github_username: 'useruser',
      location: location_van,
    )
  end

  10.times do |i|
    Student.create!(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      cohort: cohort_tor,
      uid: 1011 + i,
      token: 2011 + i,
      completed_registration: true,
      phone_number: '123-123-1234',
      github_username: 'useruser',
      location: location_to,
    )
  end

  # Quiz Stuff :PI
  quiz = Quiz.new(day: "w1d1")

  5.times do |i|
    question = Question.new(question: Faker::Lorem.sentence)

    4.times do |j|
      option = Option.new(
        answer: Faker::Lorem.sentence,
        explanation: Faker::Lorem.paragraph,
        correct: false
      )
      option.correct = true if j + 1 == 4
      question.options << option
    end
    quiz.questions << question
  end
  quiz.save!
  QuizActivity.create!(
    name: Faker::Commerce.product_name,
    start_time: 2300,
    duration: 10,
    day: "w1d1",
    quiz: quiz
  )

end
