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
      FileUtils.mkdir_p('public')
      response_string = ''
      response[2].each {|s| response_string << s }
      ::File.open(::File.join('public', env['PATH_INFO']), 'w'){|f| f << response_string }

      response
    end

    private

    def default_options
      { }
    end

  end

end
