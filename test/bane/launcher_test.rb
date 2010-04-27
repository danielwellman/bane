require File.dirname(__FILE__) + '/../test_helper'
require 'mocha'

module Bane
  module Behaviors
    class FakeTestServer < BasicBehavior
    end
  end
end

class LauncherTest < Test::Unit::TestCase
  
  def test_starts_single_server_on_specified_port
    target_port = 4000
    Bane::DelegatingGServer.expects(:new).with(equals(target_port), anything()).returns( stub_everything('fake_server') )

    launcher = Bane::Launcher.new(target_port, "FakeTestServer")
    launcher.start
  end

  def test_raises_argument_error_if_no_arguments
    assert_raises ArgumentError do
      Bane::Launcher.new
    end
  end


  def test_configuration_should_map_single_port_and_server_name
    configuration = Bane::Configuration.new(3000, "FakeTestServer")
    assert_equal 1, configuration.to_a.size, "Should have created one configuration"

    actual_entry = configuration.to_a[0]
    assert_equal 3000, actual_entry[0]
    assert_equal Bane::Behaviors::FakeTestServer, actual_entry[1]
  end

end