module Bane
  module Behaviors
    module Responders

      # Sends a large response.  Response consists of a repeated 'x' character.
      #
      # Options
      #  - length: The size in bytes of the response to send. Default: 1,000,000 bytes
      class DelugeResponse
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

    end
  end
end