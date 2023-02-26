# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'postcode_validator/version'

Gem::Specification.new do |spec|
  spec.name          = 'postcode_validator'
  spec.version       = PostcodeValidator::VERSION
  spec.licenses      = ['Apache-2.0']
  spec.authors       = ['Gaël-Ian Havard']
  spec.email         = ['gael-ian@notus.sh']

  spec.summary       = 'A simple postcode validator for Rails.'
  spec.description   = 'A simple postcode validator based on ActiveModel and Unicode CLDR.'
  spec.homepage      = 'https://github.com/notus-sh/postcode_validator'

  raise 'RubyGems 2.0 or newer is required.' unless spec.respond_to?(:metadata)

  spec.metadata = {
    'allowed_push_host' => 'https://rubygems.org',
    'rubygems_mfa_required' => 'true',

    'bug_tracker_uri' => 'https://github.com/notus-sh/postcode_validator/issues',
    'changelog_uri' => 'https://github.com/notus-sh/postcode_validator/blob/main/CHANGELOG.md',
    'homepage_uri' => 'https://github.com/notus-sh/postcode_validator',
    'source_code_uri' => 'https://github.com/notus-sh/postcode_validator',
    'funding_uri' => 'https://opencollective.com/notus-sh'
  }

  spec.require_paths = ['lib']

  excluded_dirs = %r{^(.github|dev|spec)/}
  excluded_files = %w[.gitignore .rspec .rubocop.yml Gemfile Gemfile.lock Rakefile]
  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(excluded_dirs) || excluded_files.include?(f)
  end

  spec.required_ruby_version = '>= 2.6'

  spec.add_runtime_dependency     'twitter_cldr',   '> 4.4.0'

  # Optional dependencies, used in tests
  spec.add_development_dependency 'activemodel',    '> 3.2.0'
  spec.add_development_dependency 'activesupport',  '> 3.2.0'

  # Development tools
  spec.add_development_dependency 'bundler',        '~> 2.1'
  spec.add_development_dependency 'rake',           '~> 13.0'
  spec.add_development_dependency 'rspec',          '~> 3.12.0'
end
