# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rack-staticifier}
  s.version = "0.1.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["remi"]
  s.date = %q{2009-06-15}
  s.description = %q{Staticly cache requests to any Rack application - perfect for creating static sites/blogs/etc!}
  s.email = %q{remi@remitaylor.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "README.rdoc",
     "Rakefile",
     "VERSION.yml",
     "examples/blog-to-staticify/config.ru",
     "examples/blog-to-staticify/my-blog.rb",
     "examples/blog-to-staticify/paths-to-cache",
     "examples/blog-to-staticify/posts/first.mkd",
     "examples/blog-to-staticify/posts/second.mkd",
     "examples/sinatra-blog-with-built-in-caching/my-sinatra-blog.rb",
     "lib/rack-staticifier.rb",
     "lib/rack/staticifier.rb",
     "spec/rack-staticifier_spec.rb"
  ]
  s.homepage = %q{http://github.com/remi/rack-staticifier}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Staticly cache requests to any Rack application}
  s.test_files = [
    "spec/rack-staticifier_spec.rb",
     "examples/blog-to-staticify/my-blog.rb",
     "examples/sinatra-blog-with-built-in-caching/my-sinatra-blog.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
