module Bane

  class Launcher

    def initialize(configuration, logger = $stderr)
      @configuration = configuration
      @logger = logger
    end

    def start
      @configuration.start(@logger)
    end

    def join
      @configuration.join
    end

    def stop
      @configuration.stop
    end

  end

end
