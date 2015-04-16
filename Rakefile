require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

# Use find_all_by_name instead of find_by_name as find_all_by_name will return pre-release versions
gem_specification = Gem::Specification.find_all_by_name('metasploit-yard').first

Dir[File.join(gem_specification.gem_dir, 'lib', 'tasks', '**', '*.rake')].each do |rake|
  load rake
end
