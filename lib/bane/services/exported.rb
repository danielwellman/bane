module Bane
  module Services

    EXPORTED = [NeverListen]

    # Listen only on localhost
    LOCALHOST = '127.0.0.1'

    # Deprecated - use LOCALHOST - Listen only on localhost
    DEFAULT_HOST = LOCALHOST

    # Listen on all interfaces
    ALL_INTERFACES = '0.0.0.0'

  end
end
