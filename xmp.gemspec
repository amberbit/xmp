# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "xmp/version"

Gem::Specification.new do |s|
  s.name        = "xmp"
  s.version     = XMP::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Wojciech Piekutowski"]
  s.email       = ["wojciech.piekutowski@amberbit.com"]
  s.homepage    = "https://github.com/amberbit/xmp"
  s.summary     = %q{Extensible Metadata Platform (XMP) parser for JPEG, TIFF and raw XML files}
  s.description = %q{Extensible Metadata Platform (XMP) parser extracts metadata from JPEG and TIFF image files. It also supports parsing raw XML files containing XMP.}
  s.licenses    = ["Ruby"]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.extra_rdoc_files = %w(README.md)

  s.required_ruby_version = '>= 2.6.0'

  s.add_dependency 'nokogiri', '~> 1.0'

  s.add_development_dependency 'exifr', '>= 1.0.4', '~> 1.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'logger', '~> 1.0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'simplecov'
end
