# frozen_string_literal: true

require_relative 'lib/bane/version'

Gem::Specification.new do |spec|
  spec.name = 'bane'
  spec.version = Bane::VERSION
  spec.authors = ['Daniel Wellman', 'Joe Leo']
  spec.email = ['dan@danielwellman.com']

  spec.summary = "A test harness for socket connections based upon ideas from Michael Nygard's 'Release It!'"
  spec.description = "Bane is a test harness used to test your application's interaction with\n    other servers. It is based upon the material from Michael Nygard's \"Release\n    It!\" book as described in the \"Test Harness\" chapter.\n"
  spec.homepage = 'https://github.com/danielwellman/bane'
  spec.licenses = ['BSD']
  spec.required_rubygems_version = Gem::Requirement.new('>= 0') if spec.respond_to? :required_rubygems_version=
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/danielwellman/bane/blob/main/HISTORY.md'

  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir['{bin,lib}/**/*', 'HISTORY.md', 'LICENSE', 'README.md']
  spec.require_paths = ['lib']
  spec.executables = ['bane']

  spec.extra_rdoc_files = %w[LICENSE README.md TODO]

  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rdoc', '~> 6.3'

  spec.add_dependency 'gserver', '0.0.1'
end
