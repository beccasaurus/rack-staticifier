#! /usr/bin/env ruby

%w( rubygems sinatra maruku ).each {|lib| require lib }

get '/' do
  "welcome to my blog!"
end

get '/:name.html' do
  file = File.join File.dirname(__FILE__), 'posts', "#{ params['name'] }.mkd"
  if File.file? file
    Maruku.new(File.read(file)).to_html
  else
    status 404
    "Not Found!  #{ params['name'] }"
  end
end
