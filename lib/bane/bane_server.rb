require 'gserver'

module Bane
  
  class BasicServer < GServer
    def self.inherited(clazz)
      ServiceRegistry.all_servers << clazz
    end
  end

  class CloseImmediately < BasicServer
    def serve(io)
      # do nothing
    end
  end

  class RespondRandomlyThenClose < BasicServer
    def serve(io)
      io.write Utils.random_string()
    end
  end

  class RespondRandomly < BasicServer
    def serve(io)
      while (io.gets)
        io.write Utils.random_string()
      end
    end
  end

  # Desired configuration parameters:
  #
  # * Message to respond with, or a response algorithm
  # * Time to sleep between each character
  class RespondSlowly < BasicServer
    MESSAGE = "Now is the time for all good foxes to go seeking other foxes and do good stuff for their government."

    def serve(io)
      while (io.gets)
        MESSAGE.each_char do |char|
          io.write char
          sleep 10
        end
      end
    end
  end


  class NeverRespond < BasicServer
    def serve(io)
      loop {}
    end
  end

  class DelugeResponder < BasicServer
    def serve(io)
      100_000.times { |counter| io.write(counter) }
    end
  end



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
