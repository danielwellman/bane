# frozen_string_literal: true

module Bane
  module Behaviors
    module Servers

      EXPORTED = [TimeoutInListenQueue]

      # Listen only on localhost
      LOCALHOST = '127.0.0.1'

      # Deprecated - use LOCALHOST - Listen only on localhost
      DEFAULT_HOST = LOCALHOST

      # Listen on all interfaces
      ALL_INTERFACES = '0.0.0.0'

    end
  end
end
