require 'bundler'
Bundler::GemHelper.install_tasks
require 'rspec/core/rake_task'

task :default => :spec

desc "Run all specs"
RSpec::Core::RakeTask.new do |t|
  t.ruby_opts = "-w"
  t.verbose = true
end
