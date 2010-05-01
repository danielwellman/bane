module Bane

  module Behaviors

    class BasicBehavior
      def self.inherited(clazz)
        ServiceRegistry.register(clazz)
      end
    end

    # This module can be used to wrap another behavior with
    # a "while(io.gets)" loop, which reads a line from the input and
    # then performs the given behavior.
    module ForEachLine
      def serve(io, options)
        while (io.gets)
          super(io, options)
        end
      end
    end


    class CloseImmediately < BasicBehavior
      def serve(io, options)
        # do nothing
      end
    end

    class CloseAfterPause < BasicBehavior
      def serve(io, options)
        options = {:duration => 30}.merge(options)

        sleep(options[:duration])
      end
    end

    class FixedResponse < BasicBehavior
      def serve(io, options)
        options = {:message => "Hello, world!"}.merge(options)

        io.write options[:message]
      end
    end

    class FixedResponseForEachLine < FixedResponse
      include ForEachLine
    end
    
    class RandomResponse < BasicBehavior
      def serve(io, options)
        io.write Utils.random_string()
      end
    end

    class RandomResponseForEachLine < RandomResponse
      include ForEachLine
    end

    class SlowResponse < BasicBehavior
      def serve(io, options)
        options = {:message => "Hello, world!", :pause_duration => 10}.merge(options)
        message = options[:message]
        pause_duration = options[:pause_duration]

        message.each_char do |char|
          io.write char
          sleep pause_duration
        end
      end
    end

    class SlowResponseForEachLine < SlowResponse
      include ForEachLine
    end

    class NeverRespond < BasicBehavior
      def serve(io, options)
        loop { sleep 1 }
      end
    end

    class DelugeResponse < BasicBehavior
      def serve(io, options)
        options = {:length => 1_000_000}.merge(options)
        length = options[:length]

        length.times { io.write('x') }
      end
    end

    class DelugeResponseForEachLine < DelugeResponse
      include ForEachLine
    end

  end

end
