module Rack #:nodoc:

  # Rack::Staticifier doco ...
  class Staticifier

    # the Rack application
    attr_reader :app

    # configuration options
    attr_reader :options

    def initialize app, options = nil
      @app     = app
      @options = default_options

      @options.merge(options) if options
    end

    def call env
      response = @app.call env

      # for now, cache all!
      response_string = ''
      response[2].each {|s| response_string << s }
      request_path = env['PATH_INFO']
      basename     = ::File.basename request_path
      dirname      = ::File.join 'public', ::File.dirname(request_path)
      fullpath     = ::File.join dirname, basename
      puts "FULL PATH => #{ fullpath.inspect }"
      FileUtils.mkdir_p(dirname)
      ::File.open(fullpath, 'w'){|f| f << response_string }

      response
    end

    private

    def default_options
      { }
    end

  end

end
