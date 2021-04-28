source 'https://rubygems.org'

# Specify your gem's dependencies in metasploit-erd.gemspec
gemspec

group :development do
  # markdown formatting for yard
  gem 'kramdown', platforms: :jruby
  # markdown formatting for yard
  gem 'redcarpet', platforms: :ruby
  gem 'yard'
end

group :test do
  # blank?
  gem 'activesupport', '~> 5.2.2'
  # code coverage of tests
  gem 'simplecov', :require => false
  # in-memory database for ActiveRecord association traversal
  gem 'sqlite3'
end
