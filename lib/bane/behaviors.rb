module Bane

  module Behaviors

    #TODO Delete this class and move behavior onto something else; perhaps Object?
    class BasicBehavior
      def self.simple_name
        self.name.split("::").last
      end
    end

    # This module can be used to wrap another behavior with
    # a "while(io.gets)" loop, which reads a line from the input and
    # then performs the given behavior.
    module ForEachLine
      def serve(io)
        while (io.gets)
          super(io)
        end
      end
    end

    # Closes the connection immediately after a connection is made.
    class CloseImmediately < BasicBehavior
      def serve(io)
        # do nothing
      end
    end

    # Accepts a connection, pauses a fixed duration, then closes the connection.
    #
    # Options:
    #   - duration: The number of seconds to wait before disconnect.  Default: 30
    class CloseAfterPause < BasicBehavior
      def initialize(options = {})
        @options = {duration: 30}.merge(options)
      end

      def serve(io)
        sleep(@options[:duration])
      end
    end

    # Sends a static response.
    #
    # Options:
    #   - message: The response message to send. Default: "Hello, world!"
    class FixedResponse < BasicBehavior
      def initialize(options = {})
        @options = {message: "Hello, world!"}.merge(options)
      end

      def serve(io)
        io.write @options[:message]
      end
    end

    class FixedResponseForEachLine < FixedResponse
      include ForEachLine
    end

    # Sends a newline character as the only response 
    class NewlineResponse < BasicBehavior
      def serve(io)
        io.write "\n"
      end
    end

    class NewlineResponseForEachLine < NewlineResponse
      include ForEachLine
    end

    # Sends a random response.
    class RandomResponse < BasicBehavior
      def serve(io)
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
      def initialize(options = {})
        @options = {message: "Hello, world!", pause_duration: 10}.merge(options)
      end

      def serve(io)
        message = @options[:message]
        pause_duration = @options[:pause_duration]

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
      def serve(io)
        sleep
      end
    end

    # Sends a large response.  Response consists of a repeated 'x' character.
    #
    # Options
    #  - length: The size in bytes of the response to send. Default: 1,000,000 bytes
    class DelugeResponse < BasicBehavior
      def initialize(options = {})
        @options = {length: 1_000_000}.merge(options)
      end
      def serve(io)
        length = @options[:length]

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

      def serve(io)
        io.gets # Read the request before responding
        response = NaiveHttpResponse.new(401, "Unauthorized", "text/html", UNAUTHORIZED_RESPONSE_BODY)
        io.write(response.to_s)
      end
    end

  end
end

