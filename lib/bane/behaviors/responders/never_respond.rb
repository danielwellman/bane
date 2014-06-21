module Bane
  module Behaviors
    module Responders

      # Accepts a connection and never sends a byte of data.  The connection is
      # left open indefinitely.
      class NeverRespond
        READ_TIMEOUT_IN_SECONDS = 2
        MAXIMUM_BYTES_TO_READ = 4096

        def serve(io)
          loop do
            begin
              io.read_nonblock(MAXIMUM_BYTES_TO_READ)
            rescue Errno::EAGAIN
              IO.select([io], nil, nil, READ_TIMEOUT_IN_SECONDS)
              retry # Ignore the result of IO select since we retry reads regardless of if there's data to be read or not
            rescue EOFError
              break
            end
          end
        end

      end
    end
  end
end