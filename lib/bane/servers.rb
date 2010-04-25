require 'gserver'

module Bane

  class BasicServer < GServer
    def self.inherited(clazz)
      ServiceRegistry.register(clazz)
    end
  end

  class CloseImmediately < BasicServer
    def serve(io)
      # do nothing
    end
  end

  class CloseAfterPause < BasicServer
    def serve(io)
      sleep(30)
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
      loop { sleep 1 }
    end
  end

  class DelugeResponder < BasicServer
    def serve(io)
      100_000.times { |counter| io.write(counter) }
    end
  end

end