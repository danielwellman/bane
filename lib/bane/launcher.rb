module Bane

  class Launcher

    def initialize(configurations, logger = $stderr)
      @configuration = configurations
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

    private


  end

end
