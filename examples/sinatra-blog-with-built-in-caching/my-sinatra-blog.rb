#! /usr/bin/env ruby
# %w( rubygems sinatra rack/staticifier ).each {|lib| require lib }
%w( rubygems sinatra ).each {|lib| require lib }
require File.dirname(__FILE__) + '/../lib/rack-staticifier'

use Rack::Staticifier

set :public, 'cache'

$posts = {
  'hello-world' => '<html><body>Hello World!</body></html>',
  'hi-there'    => 'Hi from my blog post text'
}

get '/' do
  "Home Page rendered at #{ Time.now }"
end

get '/:post.html' do
  name = params['post']
  
  if $posts.keys.include?(name)
    $posts[name]

  else
    status 404
    "Cannot find page: #{ name }" 
  end
end
