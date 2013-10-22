# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "bane"
  gem.homepage = "http://github.com/danielwellman/bane"
  gem.license = "BSD"
  gem.summary = "A test harness for socket connections based upon ideas from Michael Nygard's 'Release It!'"
  gem.description = <<-END
    Bane is a test harness used to test your application's interaction with
    other servers. It is based upon the material from Michael Nygard's "Release
    It!" book as described in the "Test Harness" chapter.
  END
  gem.authors = ["Daniel Wellman", "Joe Leo"]
  gem.email = "dan@danielwellman.com"
  gem.files = FileList[ 'lib/**/*', 'bin/*', 'test/**/*', 'examples/*',
    'Rakefile' ]
end
Jeweler::RubygemsDotOrgTasks.new



require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'test'
  test.test_files =  FileList['test/**/*_test.rb']
  test.verbose    =  true
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "list #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
