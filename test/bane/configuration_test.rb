require File.dirname(__FILE__) + '/../test_helper'
require 'mocha'

module Bane
  module Behaviors
    class FakeTestServer < BasicBehavior
    end
  end
end

class ConfigurationRecordTest < Test::Unit::TestCase

  include Bane
  
  def test_starts_server_on_specified_port
    target_port = 4000
    DelegatingGServer.expects(:new).with(equals(target_port), anything(), anything(), anything()).returns(fake_server)

    start_configuration(target_port, Behaviors::FakeTestServer)
  end

  def test_starts_server_with_specified_behavior
    behavior_instance = stub('constructed behavior instance')
    Behaviors::FakeTestServer.expects(:new).returns(behavior_instance)
    DelegatingGServer.expects(:new).with(anything(), equals(behavior_instance), anything(), anything()).returns(fake_server)

    start_configuration(IRRELEVANT_PORT, Behaviors::FakeTestServer)
  end

  def test_constructs_server_with_specified_options
    options = { :an_option => :a_value, :another_option => :another_value }
    DelegatingGServer.expects(:new).with(anything(), anything, has_entries(options), anything()).returns(fake_server)

    start_configuration(IRRELEVANT_PORT, Behaviors::FakeTestServer, options)
  end

  private

  def quiet_logger
    StringIO.new
  end

  def start_configuration(port, behavior, options = {})
    configuration = Configuration::ConfigurationRecord.new(port, behavior, options)
    configuration.start(quiet_logger)
  end

  def fake_server
    stub_everything('fake_server')
  end

end