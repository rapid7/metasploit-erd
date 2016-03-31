source 'https://rubygems.org'

# Specify your gem's dependencies in metasploit-erd.gemspec
gemspec

gem 'metasploit-yard', github: 'rapid7/metasploit-yard', branch: 'staging/rails-upgrade'


group :development do
  # markdown formatting for yard
  gem 'kramdown', platforms: :jruby
  # markdown formatting for yard
  gem 'redcarpet', platforms: :ruby
  # documentation
  # 0.8.7.4 has a bug where setters are not documented when @!attribute is used
  gem 'yard', '< 0.8.7.4'
end

group :test do
  # blank?
  gem 'activesupport', '~>4.1.15'
  # Upload coverage reports to coveralls.io
  gem 'coveralls', require: false
  # code coverage of tests
  gem 'simplecov', :require => false
  # in-memory database for ActiveRecord association traversal
  gem 'sqlite3'
end
