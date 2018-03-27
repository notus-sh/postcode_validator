
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "zipcode_validator/version"

Gem::Specification.new do |spec|
  spec.name          = "zipcode_validator"
  spec.version       = ZipcodeValidator::VERSION
  spec.authors       = ["Gaël-Ian Havard"]
  spec.email         = ["gael-ian@notus.sh"]

  spec.summary       = %q{A simple zipcode validator for Rails.}
  spec.description   = %q{A simple zipcode validator for Rails 3+, based on ActiveModel and Unicode CLDR.}
  spec.homepage      = "https://github.com/notus-sh/zipcode_validator"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
end
