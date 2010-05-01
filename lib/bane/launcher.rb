module Bane

  class Launcher

    def initialize(*args)
      @configurations =  Configuration.new(*args)
      @running_servers = []
    end

    def start
      @running_servers = @configurations.map do |port, server|
        start_server(server, port)
      end
    end

    def join
      @running_servers.each { |server| server.join }
    end

    def stop
      @running_servers.each { |server| server.stop }
    end

    private

    def start_server(behavior, target_port)
      new_server = DelegatingGServer.new(target_port, behavior.new)
      new_server.start
      new_server
    end

  end

end
