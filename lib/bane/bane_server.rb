require 'gserver'

module BaneUtils
  def self.random_string
    (1..rand(26)).map{|i| ('a'..'z').to_a[rand(26)]}.join
  end
end

class BasicServer < GServer

  def self.inherited(clazz)
    all_servers << clazz
  end

  def self.all_servers
    @servers ||= []
  end
end

class CloseImmediately < BasicServer
  def serve(io)
    # do nothing
  end
end

class RespondRandomlyThenClose < BasicServer
  def serve(io)
    io.write BaneUtils.random_string()
  end
end

class RespondRandomly < BasicServer
  def serve(io)
    while (io.gets)
      io.write BaneUtils.random_string()
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



class BaneServer

  def initialize(port, *server_classes)
    raise "Port is required" unless port
    @port = port.to_i
    if server_classes.empty?
      @servers = BasicServer.all_servers
    else
      @servers = server_classes.map { |name| Kernel.const_get(name) }
    end
  end

  def start
    threads = []

    @servers.each_with_index do |server, index|
      target_port = @port + index
      new_server = start_server(server, target_port)
      threads << new_server
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
