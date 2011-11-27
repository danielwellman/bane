module Bane

  class Launcher

    def initialize(servers, logger = $stderr)
      @servers = servers
      @servers.each { |server| server.stdlog = logger }
    end

    def start
      @servers.each { |server| server.start }
    end

    def join
      @servers.each { |server| server.join }
    end

    def stop
      @servers.each { |server| server.stop }
    end

  end
  
end
