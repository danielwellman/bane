require 'rubygems'
require 'rake'

BANE_GEMSPEC = Gem::Specification.new do |spec|
  spec.name = "bane"
  spec.summary = "A test harness for socket connections based upon ideas from Michael Nygard's 'Release It!'"
  spec.version = File.read(File.dirname(__FILE__) + '/VERSION').strip
  spec.authors = [ "Daniel Wellman" ]
  spec.email = "dan@danielwellman.com"
  spec.description = <<-END
    Bane is a test harness used to test your application's interaction with 
    other servers. It is based upon the material from Michael Nygard's "Release
    It!" book as described in the "Test Harness" chapter.
    END
  
  spec.executables = ['bane']
  spec.files = FileList[ 'lib/**/*', 'bin/*', 'test/**/*', 'examples/*', 
    'Rakefile' ]
  spec.add_development_dependency('mocha', '>= 0.9.8')
  spec.homepage = 'http://github.com/danielwellman/bane'
  spec.has_rdoc = true
  spec.extra_rdoc_files = [ 'TODO' ]
end

