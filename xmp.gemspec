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
  s.summary     = %q{Extensible Metadata Platform (XMP) parser}
  s.description = %q{Extensible Metadata Platform (XMP) parser}

  s.rubyforge_project = "xmp"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.extra_rdoc_files = %w(README.rdoc)

  s.add_dependency 'nokogiri', '~>1.5'

  s.add_development_dependency 'exifr', '>=1.0.4'
  s.add_development_dependency 'rspec', '~>2.0'
  s.add_development_dependency 'rake'
end
