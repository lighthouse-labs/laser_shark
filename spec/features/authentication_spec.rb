# This is definitely an overkill test.
#
require 'spec_helper'

describe 'Authentication' do

  context "with new student profile" do
    it 'creates a Student record based on Github OAuth Response Hash' do
      FactoryGirl.create :student # => 1
      visit github_session_path
      expect(Student.count).to eq(2)
    end

    it "defaults the student information based on Github" do
      visit github_session_path
      student = Student.last
      expect(student.first_name).to eq('Khurram')
      expect(student.last_name).to eq('Virani')
      expect(student.github_username).to eq('kvirani')
      expect(student.email).to eq('kvirani@lighthouselabs.ca')
      expect(student.uid).to eq('uid')
      expect(student.token).to eq('token')
    end

    it "redirects to registration page" do
      visit github_session_path
      expect(current_path).to eq(new_registration_path)
    end
  end

  context "with existing registered student" do
    let!(:student) { FactoryGirl.create :student_for_auth }

    it "does not create a new student record" do
      visit github_session_path
      expect(Student.count).to eq(1) # was already 1 due to FG.create above
    end

    it "redirects to home page (instead of registration page)" do
      visit github_session_path
      expect(current_path).to eq(root_path)
    end
  end

  context "with existing unregistered student" do
    let!(:student) { FactoryGirl.create :unregistered_student, uid: "uid", token: "token" }

    it "does not create a new student record" do
      visit github_session_path
      expect(Student.count).to eq(1) # was already 1 due to FG.create above
    end

    it "redirects to registration page" do
      visit github_session_path
      expect(current_path).to eq(new_registration_path) # was already 1 due to FG.create above
    end
  end

end
