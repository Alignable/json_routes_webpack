
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "json_routes_webpack/version"

Gem::Specification.new do |spec|
  spec.name          = "json_routes_webpack"
  spec.version       = JsonRoutesWebpack::VERSION
  spec.authors       = ["Jon Palmer"]
  spec.email         = ["jon@alignable.com"]

  spec.summary       = %q{Export rails routes to json for webpack js-route-loader }
  spec.description   = %q{COnvert Ruby on Rails routes to webpack js-route-loader format and export to a json file.}
  spec.homepage      = "https://github.com/Alignable/json_routes_webpack"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "railties", ">= 5.1"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-mocks", "~> 3.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "codecov"
end
