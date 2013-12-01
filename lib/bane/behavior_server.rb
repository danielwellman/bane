require 'gserver'

module Bane
  module Services

    class BehaviorServer

      def initialize(port, behavior, host = Services::DEFAULT_HOST)
        @server = DelegatingGServer.new(port, behavior, host)
      end

      def start
        @server.start
      end

      def join
        @server.join
      end

      def stop
        @server.stop
      end

      def stdlog=(logger)
        @server.stdlog=logger
      end
    end

    class DelegatingGServer < GServer

      def initialize(port, behavior, host)
        super(port, host)
        @behavior = behavior
        self.audit = true
      end

      def serve(io)
        @behavior.serve(io)
      end

      def to_s
        "<Bane::BehaviorServer: port=#{@port}, behavior=#{@behavior.class}>"
      end

      protected

      alias_method :original_log, :log

      def log(message)
        original_log("#{@behavior.class.unqualified_name} #{@host}:#{@port} #{message}")
      end

      def connecting(client)
        addr = client.peeraddr
        log("client:#{addr[1]} #{addr[2]}<#{addr[3]}> connect")
      end

      def disconnecting(client_port)
        log("client:#{client_port} disconnect")
      end

      def starting
        log('start')
      end

      def stopping
        log('stop')
      end
    end
  end
end