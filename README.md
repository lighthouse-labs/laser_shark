LaserShark
=========

## Ruby / Rails

This project is built with:
* ruby 2.1.0 (mentioned in the Gemfile)
* rails 4.1.0 (rc2 for now)
* slim instead of erb/haml
* postgres 9.x
* bourbon instead of bootstrap/foundation
* phantomjs (use `brew` to install) for integration test driver
  * Please make sure your phantomjs brew package is up2date: `brew update && brew upgrade phantomjs`
* poltergeist for phantomjs driver

## Setup

1. clone
2. `bundle install`
3. Setup your `config/database.yml` based off `config/database.example.yml` (`cp` it)
4. `rake db:setup`

## Server

1. Use guard to start the server and run the tests: `bundle exec guard`
