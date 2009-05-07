module Rack #:nodoc:

  # Rack::Staticifier is Rack middleware for staticly caching responses.
  #
  # ==== Usage
  #
  #    # this will cache ALL responses in a 'cache' directory
  #    use Rack::Staticifier
  #  
  #    # this will cache ALL responses in a 'public/my/cached/stuff' directory
  #    use Rack::Staticifier, :root => 'public/my/cached/stuff'
  #  
  #    # this will only cache requests with 'foo' in the URL
  #    use Rack::Staticifier do |env, response|
  #      env['PATH_INFO'].include?('foo')
  #    end
  #  
  #    # this will only cache requests with 'hi' in the response body
  #    use Rack::Staticifier do |env, response|
  #      # response is a regular Rack response, eg. [200, {}, ['hi there']]
  #      body = ''
  #      response.last.each {|string| body << string }
  #      body.include?('hi')
  #    end
  #  
  #    # this will only cache requests with 'foo' in the URL (incase you don't want to pass a block)
  #    use Rack::Staticifier, :cache_if => lambda { |env, response| env['PATH_INFO'].include?('foo') }
  #
  class Staticifier

    STATUS_CODES_NOT_TO_CACHE = [ 304 ]

    # the Rack application
    attr_reader :app

    # configuration options
    attr_reader :config

    def initialize app, config_options = nil, &block
      @app    = app
      @config = default_config_options

      config.merge!(config_options) if config_options
      config[:cache_if] = block     if block
    end

    def call env
      response = @app.call env
      cache_response(env, response) if should_cache_response?(env, response)
      response
    end

    private

    def default_config_options
      { :root => 'cache' }
    end

    def should_cache_response? env, response
      return false if STATUS_CODES_NOT_TO_CACHE.include?(response.first) # there are certain HTTP Status Codes we should never cache
      return false if response.last.respond_to?(:to_path) # we don't cache Rack::File's
      return true unless config.keys.include?(:cache_if) and config[:cache_if].respond_to?(:call) # true if no cache_if / block

      should_cache = config[:cache_if].call(env, response)
      should_cache
    end

    def cache_response env, response
      request_path = env['PATH_INFO']
      request_path << 'index.html' if request_path.end_with?('/')

      basename     = ::File.basename request_path
      dirname      = ::File.join config[:root], ::File.dirname(request_path)
      fullpath     = ::File.join dirname, basename

      FileUtils.mkdir_p(dirname)
      ::File.open(fullpath, 'w'){|f| f << response_body(response) }
    end

    def response_body response
      body = ''
      response.last.each {|string| body << string } # per the Rack spec, the last object should respond to #each
      body
    end

  end

end
