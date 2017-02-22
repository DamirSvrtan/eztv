# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "eztv"
  spec.version       = "0.0.6"
  spec.authors       = ["Damir Svrtan"]
  spec.email         = ["damir.svrtan@gmail.com"]
  spec.summary       = "EZTV wrapper in Ruby"
  spec.description   = "EZTV wrapper for the catastrophic EZTV API."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"

  spec.add_runtime_dependency "nokogiri", "~> 1.6.8.1"
  spec.add_runtime_dependency "httparty"
  spec.add_runtime_dependency "pry"
end
