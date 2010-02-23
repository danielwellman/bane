require 'socket'

class BasicServer
  def initialize(port)
    @port = port
  end

  def start
    server = TCPServer.new('localhost', @port)
    log "Listening on port #{@port}"
    while (session = server.accept)
      log "Accept #{session}"
      handle_session(session)
      session.close
      log "Closed #{session}"
    end
  end

  def log(message)
    puts "#{Time.now.strftime('%H:%M')} - #{self.class} #{message}"
  end

  def self.inherited(clazz)
    all_servers << clazz
  end

  def self.all_servers
    @servers ||= []
  end
end

class CloseImmediately < BasicServer
  def handle_session(session)
    # do nothing
  end
end

class RespondRandomlyThenClose < BasicServer
  def handle_session(session)
    random_string = (1..rand(26)).map{|i| ('a'..'z').to_a[rand(26)]}.join
    session.write random_string
  end
end

class RespondRandomly < BasicServer
  def handle_session(session)
    while (session.gets)
      random_string = (1..rand(26)).map{|i| ('a'..'z').to_a[rand(26)]}.join
      session.write random_string
    end
  end
end

# Desired configuration parameters:
#
# * Message to respond with, or a response algorithm
# * Time to sleep between each character
class RespondSlowly < BasicServer
  MESSAGE = "Now is the time for all good foxes to go seeking other foxes and do good stuff for their government."

  def handle_session(session)
    while (session.gets)
      MESSAGE.each_char do |char|
        session.write char
        sleep 10
      end
    end
  end
end


class NeverRespond < BasicServer
  def handle_session(session)
    loop {}
  end
end

class DelugeResponder < BasicServer
  def handle_session(session)
    100_000.times { |counter| session.write(counter) }
  end
end



class BaneServer

  def initialize(port)
    raise "Port is required" unless port
    @port = port.to_i
    @servers = BasicServer.all_servers
  end

  def start
    threads = []

    @servers.each_with_index do |server, index|
      threads << Thread.new(server, @port + index) do |server_class, port|
        server_class.new(port).start
      end
    end

    threads.each { |thr| thr.join }
  end
end

if __FILE__ == $PROGRAM_NAME
  BaneServer.new(ARGV[0]).start
end
