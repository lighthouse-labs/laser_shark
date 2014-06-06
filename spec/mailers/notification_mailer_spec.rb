require "spec_helper"

describe NotificationMailer do
  # describe ".signup" do
  #   let(:recipient) { random_email }
  #   let(:email) { NotificationMailer.signup(recipient) }

  #   it { email.from.should == [ "sender@domain.com" ] }
  #   it { email.to.should == [ recipient ] }
  #   it { email.subject.should == "Welcome" }
  # end

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

  it 'renders the receiver email' do
    ActionMailer::Base.deliveries.first.to.should == [@user.email]
  end

  it 'should set the subject to the correct subject' do
    ActionMailer::Base.deliveries.first.subject.should == 'Welcome to Compass'
  end

  it 'renders the sender email' do  
    ActionMailer::Base.deliveries.first.from.should == ['hello@compass.lighthouselabs.ca']
  end

end