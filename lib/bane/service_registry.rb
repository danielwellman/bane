module Bane

  module ServiceRegistry
    def self.all_servers
      @servers ||= []
    end

    def self.all_server_names
      all_servers.map(&:simple_name).sort
    end

    def self.register(server)
      all_servers << server unless all_servers.include?(server)
    end

    def self.unregister(server)
      all_servers.delete server
    end
  end

end