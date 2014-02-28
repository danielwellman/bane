module Bane

  module Behaviors

    class EchoResponse
      def serve(io)
        while(input = io.gets)
          io.write(input)
        end
        io.close
      end
    end

  end
end

