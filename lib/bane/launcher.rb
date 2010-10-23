module Bane

  class Launcher

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

  end
  
end
