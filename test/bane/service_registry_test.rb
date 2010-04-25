require File.dirname(__FILE__) + '/../test_helper'

class ServiceRegistryTest < Test::Unit::TestCase

  include Bane
  
  def test_registry_adds_and_removes_servers
    fake = fake_server

    ServiceRegistry.register(fake)
    assert ServiceRegistry.all_servers.include?(fake), "Should have added the new server"

    ServiceRegistry.unregister(fake)
    assert !(ServiceRegistry.all_servers.include?(fake)), "Should have removed the new server"
  end

  def fake_server
    Class.new
  end
end
