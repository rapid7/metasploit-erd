# Metasploit::ERD [![Build Status](https://travis-ci.org/rapid7/metasploit-erd.svg?branch=feature/gem-skeleton)](https://travis-ci.org/rapid7/metasploit-erd)[![Code Climate](https://codeclimate.com/github/rapid7/metasploit-erd.png)](https://codeclimate.com/github/rapid7/metasploit-erd)[![Coverage Status](https://coveralls.io/repos/rapid7/metasploit-erd/badge.png)](https://coveralls.io/r/rapid7/metasploit-erd)[![Dependency Status](https://gemnasium.com/rapid7/metasploit-erd.png)](https://gemnasium.com/rapid7/metasploit-erd)[![Gem Version](https://badge.fury.io/rb/metasploit-erd.png)](http://badge.fury.io/rb/metasploit-erd)

Traces the `belongs_to` associations on `ActiveRecord::Base.descendants` to find the minimum cluster in which all
foreign keys are fulfilled in the Entity-Relationship Diagram.'

## Versioning

`Metasploit::ERD` is versioned using [semantic versioning 2.0](http://semver.org/spec/v2.0.0.html).  Each branch
should set `Metasploit::ERD::Version::PRERELEASE` to the branch name, while master should have no `PRERELEASE`
and the `PRERELEASE` section of `Metasploit::ERD::VERSION` does not exist.

## Installation

Add this line to your application's Gemfile:

    gem 'metasploit-erd'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install metasploit-erd

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( http://github.com/<my-github-username>/metasploit-erd/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
