module Bane

  class Launcher

    def initialize(port, *behavior_classes)
      raise "Port is required" unless port
      @port = port.to_i
      @behavior_classes = lookup_behavior_classes(behavior_classes)
      @running_servers = []
    end

    def start
      @behavior_classes.each_with_index do |server, index|
        @running_servers << start_server(server, @port + index)
      end

      @running_servers.each { |thr| thr.join }
    end

    def stop
      @running_servers.each { |thr| thr.stop }
    end

    private

    def lookup_behavior_classes(server_classes)
      if server_classes.empty?
        ServiceRegistry.all_servers
      else
        server_classes.map { |name| Bane.const_get(name) }
      end
    end

    def start_server(behavior, target_port)
      new_server = DelegatingGServer.new(target_port, behavior)
      new_server.start
      new_server
    end

  end

end
