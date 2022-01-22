# frozen_string_literal: true

module Bane
  module Behaviors
    module Responders

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

    end
  end
end