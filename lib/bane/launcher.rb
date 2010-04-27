module Bane

  class Launcher

    def initialize(port, *behavior_classes)
      @configurations =  Configuration.new(port, behavior_classes)
      @running_servers = []
    end

    def start
      @running_servers = @configurations.map do |port, server|
        start_server(server, port)
      end
    end

    def join
      @running_servers.each { |thr| thr.join }
    end

    def stop
      @running_servers.each { |thr| thr.stop }
    end

    private

    def start_server(behavior, target_port)
      new_server = DelegatingGServer.new(target_port, behavior.new)
      new_server.start
      new_server
    end

  end

  class Configuration

    include Enumerable

    def initialize(port, behavior_classes)
      raise "Port is required" unless port
      port = port.to_i
      
      @configurations = []

      if (behavior_classes.empty?)
        setup(port, ServiceRegistry.all_servers)
      else
        setup(port, behavior_classes)
      end
    end

    def each
      @configurations.each do |entry|
        yield entry[:port], entry[:server]
      end
    end

    private

    def setup(port, behavior_classes)
      locator = Behaviors::Locator.new
      behavior_classes.each_with_index do |server, index|
        @configurations << { :port => port + index, :server => locator.find(server) }
      end
    end
  end
end
