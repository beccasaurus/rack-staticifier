# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rack-staticifier}
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["remi"]
  s.date = %q{2009-05-07}
  s.default_executable = %q{staticify}
  s.description = %q{Staticly cache requests to any Rack application - perfect for creating static sites/blogs/etc!}
  s.email = %q{remi@remitaylor.com}
  s.executables = ["staticify"]
  s.files = ["Rakefile", "VERSION.yml", "README.rdoc", "lib/rack-staticifier.rb", "lib/rack", "lib/rack/staticifier.rb", "spec/rack-staticifier_spec.rb", "bin/staticify", "examples/sinatra-blog-with-built-in-caching", "examples/sinatra-blog-with-built-in-caching/my-sinatra-blog.rb", "examples/blog-to-staticify", "examples/blog-to-staticify/posts", "examples/blog-to-staticify/posts/first.mkd", "examples/blog-to-staticify/posts/second.mkd", "examples/blog-to-staticify/my-blog.rb", "examples/blog-to-staticify/config.ru", "examples/blog-to-staticify/paths-to-cache"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/remi/rack-staticifier}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Staticly cache requests to any Rack application}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<remi-rackbox>, [">= 0"])
    else
      s.add_dependency(%q<remi-rackbox>, [">= 0"])
    end
  else
    s.add_dependency(%q<remi-rackbox>, [">= 0"])
  end
end
