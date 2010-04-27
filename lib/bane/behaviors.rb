module Bane

  class BasicBehavior
    def self.inherited(clazz)
      ServiceRegistry.register(clazz)
    end
  end


  class CloseImmediately < BasicBehavior
    def serve(io, options)
      # do nothing
    end
  end

  class CloseAfterPause < BasicBehavior
    def serve(io, options)
      options = { :duration => 30 }.merge(options)
      
      sleep(options[:duration])
    end
  end

  class RandomResponseThenClose < BasicBehavior
    def serve(io, options)
      io.write Utils.random_string()
    end
  end

  class RandomResponse < BasicBehavior
    def serve(io, options)
      while (io.gets)
        io.write Utils.random_string()
      end
    end
  end

  class SlowResponse < BasicBehavior
    MESSAGE = "Now is the time for all good foxes to go seeking other foxes and do good stuff for their government."

    def serve(io, options)
      while (io.gets)
        MESSAGE.each_char do |char|
          io.write char
          sleep 10
        end
      end
    end
  end

  class NeverRespond < BasicBehavior
    def serve(io, options)
      loop { sleep 1 }
    end
  end

  class DelugeResponse < BasicBehavior
    def serve(io, options)
      options = { :length => 1_000_000 }.merge(options)
      length = options[:length]

      length.times { io.write('x') }
    end
  end

end