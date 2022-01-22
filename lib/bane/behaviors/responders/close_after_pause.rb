# frozen_string_literal: true

module Bane
  module Behaviors
    module Responders

      # Accepts a connection, pauses a fixed duration, then closes the connection.
      #
      # Options:
      #   - duration: The number of seconds to wait before disconnect.  Default: 30
      class CloseAfterPause
        def initialize(options = {})
          @options = {duration: 30}.merge(options)
        end

        def serve(io)
          sleep(@options[:duration])
        end
      end

    end
  end
end