module Bane
  module Behaviors
    module Responders

      # Sends a newline character as the only response
      class NewlineResponse
        def serve(io)
          io.write "\n"
        end
      end

      class NewlineResponseForEachLine < NewlineResponse
        include ForEachLine
      end

    end
  end
end