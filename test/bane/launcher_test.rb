require File.dirname(__FILE__) + '/../test_helper'
require 'mocha'

module Bane
  module Behaviors
    class FakeTestServer < BasicBehavior
    end
  end
end

class LauncherTest < Test::Unit::TestCase

  include Bane

  def test_starts_server_on_specified_port
    target_port = 4000
    DelegatingGServer.expects(:new).with(equals(target_port), anything(), anything(), anything()).returns(fake_server)

    launch_with_configuration(target_port, Behaviors::FakeTestServer)
  end

  def test_starts_server_with_specified_behavior
    behavior_instance = stub('constructed behavior instance')
    Behaviors::FakeTestServer.expects(:new).returns(behavior_instance)
    DelegatingGServer.expects(:new).with(anything(), equals(behavior_instance), anything(), anything()).returns(fake_server)

    launch_with_configuration(IRRELEVANT_PORT, Behaviors::FakeTestServer)
  end

  def test_constructs_server_with_specified_options
    options = { :an_option => :a_value, :another_option => :another_value }
    DelegatingGServer.expects(:new).with(anything(), anything, has_entries(options), anything()).returns(fake_server)

    launch_with_configuration(IRRELEVANT_PORT, Behaviors::FakeTestServer, options)
  end

  private

  def launch_with_configuration(target_port, behavior, options = {})
    configuration = configuration_with(target_port, behavior, options)
    launcher = Launcher.new(configuration)
    launcher.start
  end

  def configuration_with(port, behavior, options)
    Configuration.new([Configuration::ConfigurationRecord.new(port, behavior, options)])  
  end

  def fake_server
    stub_everything('fake_server')
  end

end