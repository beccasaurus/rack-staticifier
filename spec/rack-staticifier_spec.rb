require 'rubygems'
require 'rackbox'
require 'fileutils'

require File.dirname(__FILE__) + '/../lib/rack-staticifier'

describe Rack::Staticifier do

  before do
    %w( public cache foo ).each {|dir| FileUtils.rm_rf dir }
    @app = lambda {|env| [200, {}, ["hello from #{env['PATH_INFO']}"]] }
  end

  after :all do
    %w( public cache foo ).each {|dir| FileUtils.rm_rf dir } # clean up!
  end

  it 'should render index.html for any requests ending in a slash' do
    app = Rack::Staticifier.new @app

    # for the '/' route
    File.file?("cache/index.html").should be_false
    RackBox.request app, "/"
    File.file?("cache/index.html").should be_true
    File.read("cache/index.html").should == "hello from /"

    %w( foo/ bar/ ).each do |uri|
      File.file?("cache/#{uri}index.html").should be_false
      RackBox.request app, "/#{uri}"
      File.file?("cache/#{uri}index.html").should be_true
      File.read("cache/#{uri}index.html").should == "hello from /#{uri}"
    end
  end

  it 'should cache all requests by default (in cache directory)' do
    app = Rack::Staticifier.new @app

    %w( foo bar ).each do |uri|
      File.file?("cache/#{uri}.html").should be_false
      RackBox.request app, "/#{uri}.html"
      File.file?("cache/#{uri}.html").should be_true
      File.read("cache/#{uri}.html").should == "hello from /#{uri}.html"
    end
  end

  it 'should cache all requests in a custom directory' do
    app = Rack::Staticifier.new @app, :root => 'foo'

    %w( foo bar ).each do |uri|
      File.file?("foo/#{uri}.html").should be_false
      RackBox.request app, "/#{uri}.html"
      File.file?("foo/#{uri}.html").should be_true
      File.read("foo/#{uri}.html").should == "hello from /#{uri}.html"
    end
  end

  it 'should cache all requests in a custom subdirectory' do
    app = Rack::Staticifier.new @app, :root => 'foo/bar'

    %w( foo bar ).each do |uri|
      File.file?("foo/bar/#{uri}.html").should be_false
      RackBox.request app, "/#{uri}.html"
      File.file?("foo/bar/#{uri}.html").should be_true
      File.read("foo/bar/#{uri}.html").should == "hello from /#{uri}.html"
    end
  end

  it 'should cache requests with slashes in them (create subdirectories)' do
    app = Rack::Staticifier.new @app, :root => 'foo'

    %w( hi/there a/b/c/1/2/3 totally/neato ).each do |uri|
      File.file?("foo/#{uri}.html").should be_false
      RackBox.request app, "/#{uri}.html"
      File.file?("foo/#{uri}.html").should be_true
      File.read("foo/#{uri}.html").should == "hello from /#{uri}.html"
    end
  end

  it 'should be able to only cache requests based on request environment' do
    app = Rack::Staticifier.new @app, :cache_if => lambda {|env,resp| env['PATH_INFO'].include?('cache') }

    %w( hi there crazy/person ).each do |uri|
      File.file?("cache/#{uri}.html").should be_false
      RackBox.request app, "/#{uri}.html"
      File.file?("cache/#{uri}.html").should be_false
    end

    %w( cache cache-me please/cache/me ).each do |uri|
      File.file?("cache/#{uri}.html").should be_false
      RackBox.request app, "/#{uri}.html"
      File.file?("cache/#{uri}.html").should be_true
      File.read("cache/#{uri}.html").should == "hello from /#{uri}.html"
    end
  end

  it 'should be able to only cache requests based on request environment (by passing a block)' do
    app = Rack::Staticifier.new(@app){ |env,resp| env['PATH_INFO'].include?('cache') }

    %w( hi there crazy/person ).each do |uri|
      File.file?("cache/#{uri}.html").should be_false
      RackBox.request app, "/#{uri}.html"
      File.file?("cache/#{uri}.html").should be_false
    end

    %w( cache cache-me please/cache/me ).each do |uri|
      File.file?("cache/#{uri}.html").should be_false
      RackBox.request app, "/#{uri}.html"
      File.file?("cache/#{uri}.html").should be_true
      File.read("cache/#{uri}.html").should == "hello from /#{uri}.html"
    end
  end

  it 'should be able to only cache requests based on generated response' do
    app = Rack::Staticifier.new @app, :cache_if => lambda {|env,resp|
      body = ''
      resp[2].each {|s| body << s }
      body.include?("hello from /foo")
    }

    %w( nope hi not/start/with/foo/x nor-me-foo ).each do |uri|
      File.file?("cache/#{uri}.html").should be_false
      RackBox.request app, "/#{uri}.html"
      File.file?("cache/#{uri}.html").should be_false
    end

    %w( foo fooooo foo/bar ).each do |uri|
      File.file?("cache/#{uri}.html").should be_false
      RackBox.request app, "/#{uri}.html"
      File.file?("cache/#{uri}.html").should be_true
      File.read("cache/#{uri}.html").should == "hello from /#{uri}.html"
    end
  end

  it 'should not be cache a Rack::File (#to_path)' do
    pending "either RackBox or Rack::MockRequest isn't happy about running this"

=begin
1)
TypeError in 'Rack::Staticifier should not be cache a Rack::File (#to_path)'
can't convert nil into String
/usr/lib/ruby/gems/1.8/gems/rack-1.0.0/lib/rack/file.rb:81:in `initialize'
/usr/lib/ruby/gems/1.8/gems/rack-1.0.0/lib/rack/file.rb:81:in `open'
/usr/lib/ruby/gems/1.8/gems/rack-1.0.0/lib/rack/file.rb:81:in `each'
/usr/lib/ruby/gems/1.8/gems/rack-1.0.0/lib/rack/mock.rb:126:in `initialize'
/usr/lib/ruby/gems/1.8/gems/remi-rackbox-1.1.5/lib/rackbox/rack/sticky_sessions.rb:40:in `new'
/usr/lib/ruby/gems/1.8/gems/remi-rackbox-1.1.5/lib/rackbox/rack/sticky_sessions.rb:40:in `request'
/usr/lib/ruby/gems/1.8/gems/rack-1.0.0/lib/rack/mock.rb:55:in `get'
/usr/lib/ruby/gems/1.8/gems/remi-rackbox-1.1.5/lib/rackbox/rackbox.rb:84:in `send'
/usr/lib/ruby/gems/1.8/gems/remi-rackbox-1.1.5/lib/rackbox/rackbox.rb:84:in `request'
./spec/rack-staticifier_spec.rb:137:
/usr/lib/ruby/gems/1.8/gems/rspec-1.2.2/lib/spec/example/example_methods.rb:37:in `instance_eval'
/usr/lib/ruby/gems/1.8/gems/rspec-1.2.2/lib/spec/example/example_methods.rb:37:in `execute'
/usr/lib/ruby/1.8/timeout.rb:53:in `timeout'
/usr/lib/ruby/gems/1.8/gems/rspec-1.2.2/lib/spec/example/example_methods.rb:34:in `execute'
/usr/lib/ruby/gems/1.8/gems/rspec-1.2.2/lib/spec/example/example_group_methods.rb:208:in `execute_examples'
/usr/lib/ruby/gems/1.8/gems/rspec-1.2.2/lib/spec/example/example_group_methods.rb:206:in `each'
/usr/lib/ruby/gems/1.8/gems/rspec-1.2.2/lib/spec/example/example_group_methods.rb:206:in `execute_examples'
/usr/lib/ruby/gems/1.8/gems/rspec-1.2.2/lib/spec/example/example_group_methods.rb:104:in `run'
/usr/lib/ruby/gems/1.8/gems/rspec-1.2.2/lib/spec/runner/example_group_runner.rb:23:in `run'
/usr/lib/ruby/gems/1.8/gems/rspec-1.2.2/lib/spec/runner/example_group_runner.rb:22:in `each'
/usr/lib/ruby/gems/1.8/gems/rspec-1.2.2/lib/spec/runner/example_group_runner.rb:22:in `run'
/usr/lib/ruby/gems/1.8/gems/rspec-1.2.2/lib/spec/runner/options.rb:117:in `run_examples'
/usr/lib/ruby/gems/1.8/gems/rspec-1.2.2/lib/spec/runner/command_line.rb:9:in `run'
/usr/lib/ruby/gems/1.8/gems/rspec-1.2.2/bin/spec:4:
/usr/bin/spec:19:in `load'
/usr/bin/spec:19:
=end

    app = lambda {|env| [200, {}, Rack::File.new(__FILE__)] }
    File.file?("cache/foo.html").should be_false
    RackBox.request app, "/foo.html"
    File.file?("cache/foo.html").should be_false # shouldn't be cached!

    # just double check ...
    app = lambda {|env| [200, {}, ["cache me!"]] }
    File.file?("cache/foo.html").should be_false
    RackBox.request app, "/foo.html"
    File.file?("cache/foo.html").should be_true # normal #each should be cached
  end

  it 'should not cache responses with certain HTTP Status Codes' do
    Rack::Staticifier::STATUS_CODES_NOT_TO_CACHE.each do |code|
      app = lambda {|env| [code, {}, ["not cached"]] }
      File.file?("foo.html").should be_false
      RackBox.request app, "/foo.html"
      File.file?("foo.html").should be_false # shouldn't be cached!
    end

    # this assumes that 304 will always be in STATUS_CODES_NOT_TO_CACHE ... want to double check!
    app = lambda {|env| [304, {}, ["not cached"]] }
    File.file?("foo.html").should be_false
    RackBox.request app, "/foo.html"
    File.file?("foo.html").should be_false # shouldn't be cached!
  end

  it 'should be able to customize the name of the cached file (?)'
  
end
