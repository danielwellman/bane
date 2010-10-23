module Bane
  
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