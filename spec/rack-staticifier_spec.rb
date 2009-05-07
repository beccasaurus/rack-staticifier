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

  it 'should handle when a body is a Rack::File instead of a string body (#each)'

  it 'should be able to customize the name of the cached file (?)'
  
end
