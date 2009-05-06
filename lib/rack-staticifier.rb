module Rack #:nodoc:

  # Rack::Staticifier doco ...
  class Staticifier

    # the Rack application
    attr_reader :app

    # configuration options
    attr_reader :config

    def initialize app, config_options = nil
      @app     = app
      @config = default_config_options

      config.merge!(config_options) if config_options
    end

    def call env
      response = @app.call env
      cache_response(response, env) if should_cache_response?(env)
      response
    end

    private

    def default_config_options
      { :root => 'public' }
    end

    def should_cache_response? env
      true
    end

    def cache_response response, env
      request_path = env['PATH_INFO']

      basename     = ::File.basename request_path
      dirname      = ::File.join config[:root], ::File.dirname(request_path) # TODO grab 'public' from the config options
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
