module Bane
  module Behaviors

    # Closes the connection immediately after a connection is made.
    class CloseImmediately
      def serve(io)
        # do nothing
      end
    end

  end
end