module Bane
  module Behaviors
    module Responders

      # Closes the connection immediately after a connection is made.
      class CloseImmediately
        def serve(io)
          # do nothing
        end
      end

    end
  end
end