module Bane

  class Launcher

    def initialize(configurations, logger = $stderr)
      @configuration = configurations
      @logger = logger
      @running_servers = []
    end

    def start
      @running_servers = @configuration.map do |port, behavior, options|
        start_server(behavior, port, options)
      end
    end

    def join
      @running_servers.each { |server| server.join }
    end

    def stop
      @running_servers.each { |server| server.stop }
    end

    private

    def start_server(behavior, target_port, options)
      new_server = DelegatingGServer.new(target_port, behavior.new, options, @logger)
      new_server.start
      new_server
    end

  end

end
