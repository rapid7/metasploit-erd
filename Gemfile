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
  # code coverage of tests
  gem 'simplecov', :require => false
  # in-memory database for ActiveRecord association traversal
  rails_version = ENV['RAILS_VERSION'].to_s[/\d+(?:\.\d+){0,2}/]
  sqlite3_requirements = if rails_version && rails_version.split('.').first.to_i < 8
                           ['~> 1.4']
                         else
                           ['>= 2.1', '< 3.0']
                         end
  gem 'sqlite3', *sqlite3_requirements
end
