LaserShark
=========

[![wercker status](https://app.wercker.com/status/6070c1bb6d7619eb6e874b177dc3f995/m/ "wercker status")](https://app.wercker.com/project/bykey/6070c1bb6d7619eb6e874b177dc3f995)

[![Code Climate](https://codeclimate.com/github/lighthouse-labs/laser_shark.png)](https://codeclimate.com/github/lighthouse-labs/laser_shark)

[![Code Climate](https://codeclimate.com/github/lighthouse-labs/laser_shark/coverage.png)](https://codeclimate.com/github/lighthouse-labs/laser_shark/code?sort=covered_percent&sort_direction=desc)

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
5. Create an entry in your `/etc/hosts` called beacon.dev pointing to 127.0.0.1 so that your dev URL becomes `http://beacon.dev:3000/` instead of `http://localhost:3000/`
6. Create a Github App (see below)

## Github App Setup

1. Create a Github application on your Github profile (for your dev environment): <https://github.com/settings/applications/new>
2. Specify `http://beacon.dev:3000/auth/github/callback` as the Callback URL
3. Add the OAuth client ID and client secret as `GITHUB_KEY` and `GITHUB_SECRET` to your `.env` file
4. Restart your `guard` (just in case)

## Server

1. Use guard to start the server and run the tests: `bundle exec guard`
