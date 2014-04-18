module UserAccountHelpers

  module Macros

  	def current_student(&student)
      let(:current_student, &student)
      before { login_as current_student }
    end

    def logged_out_student
      current_student { nil }
    end

    def logged_in_student
      current_student { create(:student_for_auth) }
    end

  end

  def login_as(student)
    @logged_in = true
    allow(controller).to receive(:current_student).and_return student
  end

  def logged_in?
    @logged_in ||= false
  end

end
