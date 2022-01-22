# frozen_string_literal: true

module Bane
  module Behaviors
    module Responders

      class EchoResponse
        def serve(io)
          while (input = io.gets)
            io.write(input)
          end
          io.close
        end
      end

    end
  end
end