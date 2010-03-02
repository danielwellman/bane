module Bane

  class Launcher

    def initialize(port, *server_classes)
      raise "Port is required" unless port
      @port = port.to_i
      if server_classes.empty?
        @servers = ServiceRegistry.all_servers
      else
        @servers = server_classes.map { |name| Bane.const_get(name) }
      end
    end

    def start
      threads = []

      @servers.each_with_index do |server, index|
        threads << start_server(server, @port + index)
      end

      threads.each { |thr| thr.join }
    end

    private

    def start_server(server, target_port)
      new_server = server.new(target_port)
      new_server.audit = true
      new_server.start
      new_server
    end

  end
end
