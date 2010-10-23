module Bane
  
  class Configuration

    def initialize(configurations, logger = $stderr)
      @configuration_records = configurations
      @logger = logger
      @running_servers = []
    end

    def start
      @running_servers = @configuration_records.map do |config|
        config.start(@logger)
      end
    end

    def join
      @running_servers.each { |server| server.join }
    end

    def stop
      @running_servers.each { |server| server.stop }
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
module Kernel
  def Configuration(*args)
    Bane::Configuration.new(Bane::ConfigurationParser.new(*args).configurations)
  end
end