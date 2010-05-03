module Bane
  
  class Configuration

    include Enumerable

    def initialize(configurations)
      @configurations = configurations
    end

    def each
      @configurations.each do |entry|
        yield entry.port, entry.behavior, entry.options
      end
    end


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
#
# This should likely take the constructor block from the Configuration class
# and then we can simplify this class so it's not so big.
module Kernel
  def Configuration(*args)
    Bane::Configuration.new(Bane::ConfigurationParser.new(*args).configurations)
  end
end