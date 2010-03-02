module Bane

  module ServiceRegistry
    def self.all_servers
      @servers ||= []
    end
  end

end