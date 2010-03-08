require 'rake/testtask'

desc "Run all tests"
Rake::TestTask.new do |test|
  test.libs << 'test'
  test.test_files =  FileList['test/**/*_test.rb']
  test.verbose    =  true
end