require "spec_helper"

describe NotificationMailer do

  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    @user = FactoryGirl.create(:user)
    NotificationMailer.confirmation_mailer(@user).deliver
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  it 'should send an email' do
    ActionMailer::Base.deliveries.count.should == 1
  end

  it "sends to the user's email" do
    ActionMailer::Base.deliveries.first.to.should == [@user.email]
  end

  it 'should set the subject to the correct subject' do
    ActionMailer::Base.deliveries.first.subject.should == 'Welcome to Compass'
  end

  it 'renders the sender email' do  
    ActionMailer::Base.deliveries.first.from.should == ['hello@compass.lighthouselabs.ca']
  end

end