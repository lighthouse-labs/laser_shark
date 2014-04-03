LaserShark
=========

## Ruby / Rails

This project is built with:
* ruby 2.1.0 (mentioned in the Gemfile)
* rails 4.1.0 (rc2 for now)
* slim instead of erb/haml
* postgres 9.x
* bourbon instead of bootstrap/foundation

## Setup

1. clone
2. `bundle install`
3. Setup your `config/database.yml` based off config/database.example.yml
4. `rake db:setup`

## Server

1. Use guard to start the server and run the tests: `bundle exec guard`
