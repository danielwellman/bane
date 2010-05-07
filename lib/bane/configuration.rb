module Bane
  
  class Configuration

    def initialize(configurations)
      @configurations = configurations
    end

    def start(logger)
      @configurations.map do |config|
        config.start(logger)
      end
    end

    class ConfigurationRecord

      def initialize(port, behavior, options = {})
        @port = port
        @behavior = behavior
        @options = options
      end

      def start(logger)
        new_server = DelegatingGServer.new(@port, @behavior.new, @options, logger)
        new_server.start
        new_server
      end
    end

  end

  class ConfigurationError < RuntimeError; end

  class UnknownBehaviorError < RuntimeError
    def initialize(name)
      super "Unknown behavior: #{name}"
    end
  end

end

# Helper method to easily create configuration.
#
# This should likely take the constructor block from the Configuration class
# and then we can simplify this class so it's not so big.
module Kernel
  def Configuration(*args)
    Bane::Configuration.new(Bane::ConfigurationParser.new(*args).configurations)
  end
end