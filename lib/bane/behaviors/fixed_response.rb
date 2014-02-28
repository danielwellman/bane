module Bane
  module Behaviors

    # Sends a static response.
    #
    # Options:
    #   - message: The response message to send. Default: "Hello, world!"
    class FixedResponse
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

  end
end