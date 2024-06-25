# frozen_string_literal: true

require_relative 'lib/anthropic/version'

Gem::Specification.new do |spec|
  spec.name = 'anthropic-rb'
  spec.version = Anthropic::VERSION
  spec.authors = ['Dick Davis']
  spec.email = ['dick@hey.com']

  spec.summary = 'Ruby bindings for the Anthropic API'
  spec.homepage = 'https://github.com/dickdavis/anthropic-rb'
  spec.license = 'MIT'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/dickdavis/anthropic-rb'
  spec.metadata['changelog_uri'] = 'https://github.com/dickdavis/anthropic-rb/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ spec/ .git .github/ Gemfile])
    end
  end + Dir.glob('lib/**/*.json')
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.required_ruby_version = '>= 3.2.4'
  spec.add_dependency 'httpx', '>= 1.1.5'
  spec.add_dependency 'json-schema', '>= 4.1.1'
end
