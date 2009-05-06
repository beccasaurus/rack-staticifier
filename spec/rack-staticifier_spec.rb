require 'rubygems'
require 'rackbox'
require 'fileutils'

require File.dirname(__FILE__) + '/../lib/rack-staticifier'

describe Rack::Staticifier do

  it 'should staticify all requests, by default (in public dir by default)' do
    FileUtils.rm_rf 'public'
    FileUtils.rm_rf 'my/cached/stuff'
    
    app = lambda {|env| [200, {}, ["hello from #{env['PATH_INFO']}"]] }

    # use Rack::Staticifier

    app = Rack::Staticifier.new app

    File.file?('public/foo.html').should be_false
    File.file?('public/bar.html').should be_false

    RackBox.request(app, '/foo.html')
    RackBox.request(app, '/bar.html')

    File.file?('public/foo.html').should be_true
    File.file?('public/bar.html').should be_true

    File.read('public/foo.html').should == "hello from /foo.html"

    # todo, break this into another example

    File.file?('public/subdir/hello.html').should be_false
    RackBox.request(app, '/subdir/hello.html')
    File.file?('public/subdir/hello.html').should be_true
    File.read('public/subdir/hello.html').should == "hello from /subdir/hello.html"

    # again, break this out!  configure directory ...

    File.file?('my/cached/stuff/subdir/hello.html').should be_false
    app = Rack::Staticifier.new app, :root => 'my/cached/stuff'
    RackBox.request(app, '/subdir/hello.html')
    File.file?('my/cached/stuff/subdir/hello.html').should be_true
    File.read('my/cached/stuff/subdir/hello.html').should == "hello from /subdir/hello.html"
  end

  #it 'should be able to configure the directory to save responses in'

  it 'should be able to pass regular expression(s) for paths to staticify'
  
  it 'should be able to pass a block that will be called to determine paths to staticify (staticify if returns true for env)'

end
