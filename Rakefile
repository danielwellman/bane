# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rdoc/task'
require_relative 'lib/bane/version'

Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.test_files =  FileList['test/**/*_test.rb']
  test.verbose    =  true
end

task default: :test

Rake::RDocTask.new do |rdoc|
  version = Bane::VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "list #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
