# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rack-staticifier}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["remi"]
  s.date = %q{2009-05-06}
  s.description = %q{}
  s.email = %q{remi@remitaylor.com}
  s.files = ["Rakefile", "VERSION.yml", "README.rdoc", "lib/rack-staticifier.rb", "lib/rack", "lib/rack/staticifier.rb", "spec/rack-staticifier_spec.rb", "examples/cache", "examples/cache/abcfdjskjfdsdefg.html", "examples/cache/abcdefg.html", "examples/my-sinatra-blog.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/remi/rack-staticifier}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
