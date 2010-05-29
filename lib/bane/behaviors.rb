module Bane

  module Behaviors

    class BasicBehavior
      def self.inherited(clazz)
        ServiceRegistry.register(clazz)
      end

      def self.simple_name
        self.name.split("::").last
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

    # Closes the connection immediately after a connection is made.
    class CloseImmediately < BasicBehavior
      def serve(io, options)
        # do nothing
      end
    end

    # Accepts a connection, pauses a fixed duration, then closes the connection.
    #
    # Options:
    #   - duration: The number of seconds to wait before disconnect.  Default: 30
    class CloseAfterPause < BasicBehavior
      def serve(io, options)
        options = {:duration => 30}.merge(options)

        sleep(options[:duration])
      end
    end

    # Sends a static response.
    #
    # Options:
    #   - message: The response message to send. Default: "Hello, world!"
    class FixedResponse < BasicBehavior
      def serve(io, options)
        options = {:message => "Hello, world!"}.merge(options)

        io.write options[:message]
      end
    end

    class FixedResponseForEachLine < FixedResponse
      include ForEachLine
    end

    # Sends a random response.
    class RandomResponse < BasicBehavior
      def serve(io, options)
        io.write random_string
      end

      private
      def random_string
        (1..rand(26)+1).map { |i| ('a'..'z').to_a[rand(26)] }.join
      end

    end

    class RandomResponseForEachLine < RandomResponse
      include ForEachLine
    end

    # Sends a fixed response character-by-character, pausing between each character.
    #
    # Options:
    #  - message: The response to send. Default: "Hello, world!"
    #  - pause_duration: The number of seconds to pause between each character. Default: 10 seconds
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

    # Accepts a connection and never sends a byte of data.  The connection is
    # left open indefinitely.
    class NeverRespond < BasicBehavior
      def serve(io, options)
        loop { sleep 1 }
      end
    end

    # Sends a large response.  Response consists of a repeated 'x' character.
    #
    # Options
    #  - length: The size in bytes of the response to send. Default: 1,000,000 bytes
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

    # Sends an HTTP 401 response (Unauthorized) for every request.  This
    # attempts to mimic an HTTP server by reading a line (the request)
    # and then sending the response.  This behavior responds to all
    # incoming request URLs on the running port. 
    class HttpRefuseAllCredentials < BasicBehavior
      UNAUTHORIZED_RESPONSE_BODY = <<EOF
<!DOCTYPE html>
<html>
  <head>
    <title>Bane Server</title>
  </head>
  <body>
    <h1>Unauthorized</h1>
  </body>
</html>
EOF

      def serve(io, options)
        io.gets # Read the request before responding
        response = NaiveHttpResponse.new(401, "Unauthorized", "text/html", UNAUTHORIZED_RESPONSE_BODY)
        io.write(response.to_s)
      end
    end

  end
end

