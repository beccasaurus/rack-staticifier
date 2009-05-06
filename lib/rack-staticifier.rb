module Rack #:nodoc:

  # Rack::Staticifier doco ...
  class Staticifier

    def initialize app
      @app = app
    end

    def call env
      @app.call env
    end

  end

end
