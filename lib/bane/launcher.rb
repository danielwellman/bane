module Bane

  class Launcher

    def initialize(configuration)
      @configuration = configuration
    end

    def start
      @configuration.start
    end

    def join
      @configuration.join
    end

    def stop
      @configuration.stop
    end

  end

end
