require "spec_helper"
describe ApplicationHelper do
  
  it "should calculate the integer_time_to_s" do
    integer_time_to_s(900).should eql "9:00"
    integer_time_to_s(1100).should eql "11:00"
    integer_time_to_s(930).should eql "9:30"
    integer_time_to_s(1130).should eql "11:30"
    integer_time_to_s(959).should eql "9:59"
  end


end
