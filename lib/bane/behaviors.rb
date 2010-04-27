module Bane

  class BasicBehavior
    def self.inherited(clazz)
      ServiceRegistry.register(clazz)
    end
  end


  class CloseImmediately < BasicBehavior
    def serve(io)
      # do nothing
    end
  end

  class CloseAfterPause < BasicBehavior
    def serve(io)
      sleep(30)
    end
  end

  class RandomResponseThenClose < BasicBehavior
    def serve(io)
      io.write Utils.random_string()
    end
  end

  class RandomResponse < BasicBehavior
    def serve(io)
      while (io.gets)
        io.write Utils.random_string()
      end
    end
  end

  class SlowResponse < BasicBehavior
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

  class NeverRespond < BasicBehavior
    def serve(io)
      loop { sleep 1 }
    end
  end

  class DelugeResponse < BasicBehavior
    def serve(io)
      1_000_000.times { io.write('x') }
    end
  end

end