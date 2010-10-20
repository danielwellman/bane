module Bane

  class Launcher

    def initialize(configuration, logger = $stderr)
      @configuration = configuration
      @logger = logger
      @running_servers = []
    end

    def start
      @running_servers = @configuration.start(@logger)
    end

    def join
      @running_servers.each { |server| server.join }
    end

    def stop
      @running_servers.each { |server| server.stop }
    end

  end

end
