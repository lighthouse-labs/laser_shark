Compass - by Lighthouse Labs
=========

[![wercker status](https://app.wercker.com/status/6070c1bb6d7619eb6e874b177dc3f995/m/ "wercker status")](https://app.wercker.com/project/bykey/6070c1bb6d7619eb6e874b177dc3f995) [![Code Climate](https://codeclimate.com/github/lighthouse-labs/laser_shark.png)](https://codeclimate.com/github/lighthouse-labs/laser_shark) [![Code Climate](https://codeclimate.com/github/lighthouse-labs/laser_shark/coverage.png)](https://codeclimate.com/github/lighthouse-labs/laser_shark/code?sort=covered_percent&sort_direction=desc) [![Dependency Status](https://gemnasium.com/lighthouse-labs/laser_shark.svg)](https://gemnasium.com/lighthouse-labs/laser_shark)


## Ruby / Rails

This project is built with :
* ruby 2.1.1 (mentioned in the Gemfile)
* rails 4.1.0 (rc2 for now)
* slim instead of erb/haml
* postgres 9.x
* bourbon instead of bootstrap/foundation
* phantomjs (use `brew` to install) for integration test driver
  * Please make sure your phantomjs brew package is up2date: `brew update && brew upgrade phantomjs`
* poltergeist for phantomjs driver

## Setup

Follow these steps in order please:

1. Clone the project
2. `bundle install`
3. Setup your `config/database.yml` based off `config/database.example.yml` (`cp` it)
  * _If you are using vagrant_ (which already has postgres on it): please remove `host: localhost` from both the `development` and `test` db settings. Also, please add `username: ` and `password: ` as empty keys under both sections.
4. `bin/rake db:setup`
5. Setup new DNS Alias for `localhost`:
  * From your terminal, type in `sudo nano /etc/hosts` (Mac/Linux Only)
  * Note: if you are using a VM (Vagrant, etc), this should be done on your host (main) machine, not your virtual machine
  * Add the following entry as a new line at the end of the `/etc/hosts` file: `127.0.0.1 compass.dev`.
  * Now you can go to the URL `http://compass.dev:3000/` instead of `http://localhost:3000/` for when you are working on this app.
6. Setup a `.env` file based on `.env.example` in the project root: `cp .env.example .env`
7. Create a Github App (see steps below)
8. Start the server, using the `bundle exec guard` or the `bin/rails server` command

## Github App Setup

User (student/teacher) Authentication can only happen through Github. Much like how Facebook has Apps that you need if you want to allow users to login through Facebook, we need to create an "app" on Github).

1. Create a Github application on your Github profile (for your dev environment): <https://github.com/settings/applications/new>
2. Specify `http://compass.dev:3000/auth/github/callback` as the Callback URL (when they ask you)
3. After the app is created, it gives you some keys. Add the OAuth client ID and client secret as `GITHUB_KEY` and `GITHUB_SECRET` to your `.env` file
4. Kill and Restart your local server (`guard` or `rails s` or whatever) if running

## Server

Use [guard](https://github.com/guard/guard) to start the server and run the tests: `bundle exec guard`

Alternatively, you could start the server using: `bin/rails s` and run the tests using `bin/rake spec`

## Project Management

At the moment, this project is managed via a [Public Trello Board](https://trello.com/b/5jhOVghs/laser-sharks)


## Notes

<https://github.com/wingrunr21/flat-ui-sass> was used to convert FlatUI Pro from LESS to SASS (located in `vendor/assets` )


## Activities Seed

Ask the teachers for the `activites_seed.rb` which has some activities that can be populated by the `bin/rake db:seed` command. They will send you a gist with the rb file in it.

## Custom markdown

**To make code selectable in the browser use:**

  
\`\`\`ruby-selectable
Some selectable text
Some selectable text
Some selectable text
\`\`\`

\`\`\`selectable
Some selectable text here
Some selectable text here
Some selectable text here
\`\`\`

**To make a toggleable answer section:**

```
???ruby
Some ruby code herecode
Some ruby code herecode
Some ruby code herecode
???
```

or 

```
???ruby-selectable
Some ruby code herecode
Some ruby code herecode
Some ruby code herecode
???
```

