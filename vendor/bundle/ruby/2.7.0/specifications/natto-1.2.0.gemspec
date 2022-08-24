# -*- encoding: utf-8 -*-
# stub: natto 1.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "natto".freeze
  s.version = "1.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Brooke M. Fujita".freeze]
  s.date = "2020-03-11"
  s.description = "natto provides a naturally Ruby-esque interface to MeCab. It runs on both CRuby (mri/yarv) and JRuby (jvm). It works with MeCab installations on Windows, Unix/Linux, and OS X. No compiler is necessary, as natto is not a C extension.\n".freeze
  s.email = "buruzaemon@gmail.com".freeze
  s.homepage = "https://github.com/buruzaemon/natto".freeze
  s.licenses = ["BSD".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9".freeze)
  s.requirements = ["MeCab 0.996".freeze, "FFI, 1.9.0 or greater".freeze]
  s.rubygems_version = "3.3.19".freeze
  s.summary = "A gem leveraging FFI (foreign function interface), natto combines the Ruby programming language with MeCab, the part-of-speech and morphological analyzer for the Japanese language.".freeze

  s.installed_by_version = "3.3.19" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<ffi>.freeze, [">= 1.9.0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    s.add_development_dependency(%q<minitest>.freeze, [">= 0"])
  else
    s.add_dependency(%q<ffi>.freeze, [">= 1.9.0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<minitest>.freeze, [">= 0"])
  end
end
