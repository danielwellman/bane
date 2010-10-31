require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

class ServiceRegistryTest < Test::Unit::TestCase

  include Bane
  
  def test_should_add_and_remove_behaviors
    fake = fake_behavior

    ServiceRegistry.register(fake)
    assert ServiceRegistry.all_servers.include?(fake), "Should have added the new behavior"

    ServiceRegistry.unregister(fake)
    assert !(ServiceRegistry.all_servers.include?(fake)), "Should have removed the new behavior"
  end

  def fake_behavior
    Class.new
  end
end
