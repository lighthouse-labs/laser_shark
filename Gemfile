source 'https://rubygems.org'
ruby '2.1.7'

gem 'rails', '4.2.4'
gem 'sass-rails', '~> 4.0.2'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'

# gem 'turbolinks'
gem 'sdoc', '~> 0.4.0',          group: :doc

gem 'react-rails', '~> 1.4.1'
gem 'active_model_serializers'

gem 'pg'
gem 'bcrypt-ruby'
gem 'puma'
gem 'kaminari'
gem 'readmorejs-rails'
gem 'best_in_place', github: 'bernat/best_in_place'
gem 'ace-rails-ap'

gem 'simple_form', '3.1.0.rc1'
gem 'slim-rails'
gem 'bootstrap-sass', '~> 3.3.5'
gem 'font-awesome-rails'
gem 'compass-rails'

gem 'actioncable', github: "rails/actioncable"

gem 'email_validator'

gem 'redcarpet'
gem 'teaspoon-mocha'
gem 'phantomjs'

gem 'omniauth'
gem 'omniauth-github'

gem 'octokit'

gem 'default_value_for'

gem 'carrierwave'
gem 'mini_magick'
gem 'fog'

# gem 'airbrake' # errors going to errbit actually. See errbit.rb
gem "sentry-raven"

gem 'rubyzip', '>= 1.0.0'

gem 'slack-poster'

gem 'aws-sdk-core'

gem 'faker'

gem 'interactor-rails', '~> 2.0'

group :development do
  gem 'pry'
  gem 'pry-nav'
  gem 'spring'
  gem 'quiet_assets'
  gem 'rails_layout'
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
end

group :development, :test do
  gem 'spring-commands-rspec'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'factory_girl_rails'
  gem 'rspec-rails', '2.14.2'
  gem 'dotenv'
end


group :test do
  gem 'capybara'
  # gem 'launchy'
  gem 'poltergeist'
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
  # gem 'shoulda-matchers' # not ready for 4.1

  # http://d.pr/i/N429/2oGamluY
  gem "codeclimate-test-reporter", require: nil
end

group :production, :staging do
  gem 'rails_12factor'
end
