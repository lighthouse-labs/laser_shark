namespace :import do
  require 'csv'
  desc "Import code reviews from gsheet csv file"
  task webcodereviews: :environment do
    @TEACHER_IDS = {
      raf: 292,
      steven: 419,
      mike: 633,
      khurram: 1,
      zach: 386
    }

    @STUDENT_IDS = {
      muhammad: 747,
      waza: 630
    }

    def find_teacher(code_review, location)
      if location == 'Vancouver'
        # return @VANCOUVER_TAS[code_review[0].upcase.to_sym]
        if @VANCOUVER_TAS[code_review[0].upcase.to_sym] != 'skip'
          return Teacher.find(@VANCOUVER_TAS[code_review[0].upcase.to_sym])
        else
          return false
        end
      end
      teacher_first_name = code_review[0].split(" ")[0] 
      teacher_last_name = code_review[0].split(" ")[1] 
      teacher = Teacher.filter_by_location(Location.find_by(name: 'Toronto').id).find_by('lower(first_name) = ?', teacher_first_name.to_s.downcase)
      unless teacher
        teacher = Teacher.filter_by_location(Location.find_by(name: 'Toronto').id).find_by('lower(last_name) = ?', teacher_last_name.to_s.downcase)
        unless teacher
          teacher = Teacher.find(@TEACHER_IDS[teacher_first_name.downcase.to_sym])
        end
      end
      teacher
    end

    def find_activity_submission(code_review, student)
      if (code_review[1] != '?')
        activity = Activity.search(code_review[1])
        ActivitySubmission.find_by(activity: activity, user: student) if activity
      end
    end

    def find_student(info_row, location)
      student_name = info_row[0].to_s.split(' ')
      if location == 'Toronto'
        student_email = info_row[2].to_s
      else
        student_email = info_row[1].to_s
      end
      student_first_name = student_name[0]
      student_last_name = student_name[1]
      return if ['Grochowski', 'Brooks'].any? { |last_name| student_last_name.include?(last_name) }
      student = Student.find_by(email: student_email)
      unless student
        student = Student.find_by(first_name: student_first_name, last_name: student_last_name)
        student = Student.find(@STUDENT_IDS[student_first_name.downcase.to_sym]) unless student
      end
      student
    end

    def create_code_review(student, teacher, activity_submission, date, rating)
      code_review_request = CodeReviewRequest.create(requestor: student, assistor_id: teacher.id, activity_submission: activity_submission)
      assistance = Assistance.create(assistor: teacher, assistee: student, assistance_request: code_review_request, rating: rating.to_i.floor, imported: true)
      code_review_date = Date.strptime(date, "%m/%d/%Y")
      code_review_request.update_attributes(created_at: code_review_date, updated_at: code_review_date)
      assistance.update_attributes(created_at: code_review_date, updated_at: code_review_date)
    end

    CSV.foreach(Rails.public_path.join('tor-web.csv')) do |row|
      # Find student
      if (row[0] && row[0].length > 1 && !(['January', 'February', 'March', 'Student'].any? { |term| row[0].include?(term) }))
        student = find_student(row, 'Toronto')
        # Find teacher for each code review and create code review
        row[3..row.length].each_slice(4) do |review|
          if (review[0] && (!review[0].include?("Code Review")) && (review[0] != "Mentor"))
            teacher = find_teacher(review, 'Toronto')
            activity = find_activity_submission(review, student)
            create_code_review(student, teacher, activity, review[2], review[3])
          end
        end
      end
    end

    CSV.foreach(Rails.public_path.join('van-web.csv')) do |row|
      # Find student
      if (row[0] && row[0].length > 1 && !(['Okanagan', 'January', 'February', 'Feburary', 'October', 'November', 'March', 'Student'].any? { |term| row[0].include?(term) }))
        student = find_student(row, 'Vancouver')
        if student
          # Find teacher for each code review and create code review
          row[2..row.length].each_slice(4) do |review|
            if (review[0] && review[0] != '-' && (!review[0].include?("Code Review")) && (review[0] != "Mentor"))
              teacher = find_teacher(review, "Vancouver")
              if teacher
                activity = find_activity_submission(review, student)
                create_code_review(student, teacher, activity, review[2], review[3])
              end
            end
          end
        end
      end
    end
  end
end

@VANCOUVER_TAS = {
  MG: 'skip',
  O: 442,
  BO: 741,
  RO: 442,
  WB: 514,
  RC: 738,
  SH: 770,
  DC: 743,
  MA: 6, 
  AS: 64, 
  SM: 153, 
  AK: 117, 
  BA: 163, 
  TT: 111, 
  IN: 116, 
  HH: 197, 
  AH: 50, 
  XN: 122, 
  SJ: 184, 
  DH: 154, 
  JM: 263, 
  AD: 242, 
  LF: 384, 
  MN: 298, 
  SV: 560, 
  RS: 211, 
  RL: 427, 
  SW: 547, 
  MK: 171, 
  TD: 42, 
  DB: 4, 
  CF: 498, 
  CB: 497, 
  KS: 19, 
  RT: 180, 
  ST: 553, 
  JH: 566, 
  PJ: 109, 
  KT: 209, 
  GG: 523, 
  CG: 110, 
  JL: 152, 
  KV: 1, 
  HK: 185, 
  VS: 115, 
  AY: 108, 
  MY: 160, 
  JS: 668, 
  EW: 233, 
  BS: 223, 
  BK: 107, 
  EJ: 682, 
  JG: 685, 
  DM: 691, 
  CS: 164, 
  DS: 694, 
  CR: 317, 
  DF: 238, 
  GL: 710, 
  TW: 514, 
  BL: 741, 
  RD: 442, 
  JN: 771, 
  DV: 192, 
  MM: 711, 
  VA: 740
}