require File.dirname(__FILE__) + '/../test_helper'
require 'mocha'

class ConfigurationTest < Test::Unit::TestCase

  include Bane

  def test_should_map_single_port_and_server_name
    configuration = Bane::Configuration.new(3000, "CloseAfterPause")
    assert_equal 1, configuration.to_a.size, "Should have created one configuration"

    actual_entry = configuration.to_a[0]
    assert_configuration(actual_entry, :port => 3000, :behavior => Behaviors::CloseAfterPause)
  end

  def test_should_map_multiple_servers_given_one_starting_port
    configuration = Configuration.new(3000, "CloseAfterPause", "CloseImmediately")
    assert_equal 2, configuration.to_a.size, "Should have created two configurations"

    assert_configuration(configuration.to_a[0], :port => 3000, :behavior => Behaviors::CloseAfterPause)
    assert_configuration(configuration.to_a[1], :port => 3001, :behavior => Behaviors::CloseImmediately)
  end

  def test_should_ask_service_registry_for_all_behaviors_if_none_specified
    fake_behavior = Module.new
    another_fake_behavior = Module.new

    ServiceRegistry.expects(:all_servers).returns([fake_behavior, another_fake_behavior])
    configuration = Configuration.new(3000)
    assert_equal 2, configuration.to_a.size, "Should have created two configurations"

    assert_configuration(configuration.to_a[0], :port => 3000, :behavior => fake_behavior)
    assert_configuration(configuration.to_a[1], :port => 3001, :behavior => another_fake_behavior)
  end

  def test_should_raise_exception_if_no_arguments
    assert_raises ArgumentError do
      Configuration.new
    end
  end

  private

  def assert_configuration(entry, options)
    assert_equal options[:port], entry[0], "Wrong port"
    assert_equal options[:behavior], entry[1], "Wrong behavior"
  end

end