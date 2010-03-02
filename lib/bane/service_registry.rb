module Bane

  module ServiceRegistry
    def self.all_servers
      @servers ||= []
    end

    def self.register(server)
      all_servers << server unless all_servers.include?(server)
    end
  end

end