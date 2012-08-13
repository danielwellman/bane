require 'gserver'

module Bane
  class BehaviorServer < GServer

    ALL_INTERFACES = "0.0.0.0"

    def initialize(port, behavior, options = {})
      super(port)
      @behavior = behavior
      @options = options
      self.audit = true
    end

    def serve(io)
      @behavior.serve(io, @options)
    end

    def to_s
      "<Bane::BehaviorServer: port=#{@port}, behavior=#{@behavior.class}, options=#{@options}>"
    end
    
    protected

    alias_method :original_log, :log

    def log(message)
      original_log("#{@behavior.class.simple_name} #{@host}:#{@port} #{message}")
    end

    def connecting(client)
      addr = client.peeraddr
      log("client:#{addr[1]} #{addr[2]}<#{addr[3]}> connect")
    end

    def disconnecting(client_port)
      log("client:#{client_port} disconnect")
    end

    def starting()
      log("start")
    end

    def stopping()
      log("stop")
    end
  end
end