require 'socket'

module Bane
  module Behaviors
    module Services

      class TimeoutInListenQueue

        def initialize(port, host = Services::LOCALHOST)
          @port = port
          @host = host
          self.stdlog= $stderr
        end

        def start
          @server = Socket.new(:INET, :STREAM)
          address = Socket.sockaddr_in(port, host)
          @server.bind(address) # Note that we never call listen

          log 'started'
        end

        def join
          sleep
        end

        def stop
          @server.close
          log 'stopped'
        end

        def stdlog=(logger)
          @logger = logger
        end

        def self.make(port, host)
          new(port, host)
        end

        private

        attr_reader :host, :port, :logger

        def log(message)
          logger.puts "[#{Time.new.ctime}] #{self.class.unqualified_name} #{host}:#{port} #{message}"
        end
      end

    end
  end
end