module Bane

  class Configuration

    include Enumerable

    def initialize(*args)
      port = args[0]
      raise ArgumentError, "Port is required" unless port
      port = port.to_i

      behavior_classes = args[1..-1]

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