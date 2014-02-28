module Bane
  module Behaviors

    # Accepts a connection and never sends a byte of data.  The connection is
    # left open indefinitely.
    class NeverRespond
      def serve(io)
        sleep
      end
    end

  end
end