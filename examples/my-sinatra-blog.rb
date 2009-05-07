#! /usr/bin/env ruby
%w( rubygems sinatra rack/staticifier ).each {|lib| require lib }

# sinatra serves out of the public directory by default
use Rack::Staticifier, :root => 'public' do |env, response|
  response.first == 200 # only staticly cache 200 responses, meaning /non-existent-page-name should render OK
end

$posts = {
  'hello-world' => 'Hello World!',
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
