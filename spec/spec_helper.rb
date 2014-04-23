$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

# require before 'metasploit/erd' so coverage is shown for files required by 'metasploit/erd'
require 'simplecov'
require 'coveralls'

if ENV['TRAVIS'] == 'true'
  # don't generate local report as it is inaccessible on travis-ci, which is why coveralls is being used.
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
else
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
      # either generate the local report
      SimpleCov::Formatter::HTMLFormatter
  ]
end

require 'metasploit/erd'
