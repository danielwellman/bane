module Bane
  
  module Configuration

    class ConfigurationRecord

      attr_reader :port, :behavior, :options

      def initialize(port, behavior, options = {})
        @port = port
        @behavior = behavior
        @options = options
      end

    end

  end

  class ConfigurationError < RuntimeError; end

  class UnknownBehaviorError < RuntimeError
    def initialize(name)
      super "Unknown behavior: #{name}"
    end
  end

end

# Helper method to easily create configuration.
module Kernel
  def Configuration(*args)
    Bane::ConfigurationParser.new(*args).configurations
  end
end