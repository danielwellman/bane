require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "bane"
    gem.summary = "A test harness for socket connections based upon ideas from Michael Nygard's 'Release It!'"
    gem.description = <<-END
      Bane is a test harness used to test your application's interaction with
      other servers. It is based upon the material from Michael Nygard's "Release
      It!" book as described in the "Test Harness" chapter.
    END
    gem.authors = ["Daniel Wellman"]
    gem.email = "dan@danielwellman.com"
    gem.homepage = "http://github.com/danielwellman/bane"
    gem.files = FileList[ 'lib/**/*', 'bin/*', 'test/**/*', 'examples/*',
      'Rakefile' ]
    gem.add_development_dependency('mocha', '>= 0.9.8')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
desc "Run all tests"
Rake::TestTask.new do |test|
  test.libs << 'test'
  test.test_files =  FileList['test/**/*_test.rb']
  test.verbose    =  true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end


task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "bane #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
