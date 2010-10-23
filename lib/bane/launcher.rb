module Bane

  class Launcher

    def initialize(servers, logger = $stderr)
      @servers = servers
      @logger = logger
    end

    def start
      @servers.each do |server|
        server.stdlog = @logger
        server.start
      end
    end

    def join
      @servers.each { |server| server.join }
    end

    def stop
      @servers.each { |server| server.stop }
    end

  end
  
end
