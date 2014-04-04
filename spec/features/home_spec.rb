# This is definitely an overkill test.
#
require 'spec_helper'

describe 'Home page' do

  it 'works (to prove that poltergeist and phantomjs based integration tests are working) - REMOVE THIS TEST LATER', js: true do
    visit root_path
    # page.save_screenshot('home.png')
    expect(page).to have_content('Home')
  end
end
