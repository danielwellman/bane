require File.dirname(__FILE__) + '/../test_helper'
require 'mocha'

class ConfigurationTest < Test::Unit::TestCase

  include Bane

  IRRELEVANT_BEHAVIOR = Module.new

  def test_should_map_single_port_and_server_name
    parser = ConfigurationParser.new(3000, "CloseAfterPause")
    assert_matches_configuration([
            {:port => 3000, :behavior => Behaviors::CloseAfterPause}
    ], parser)
  end

  def test_should_map_multiple_servers_given_one_starting_port
    parser = ConfigurationParser.new(3000, "CloseImmediately", "CloseAfterPause")
    assert_matches_configuration([
            {:port => 3000, :behavior => Behaviors::CloseImmediately},
            {:port => 3001, :behavior => Behaviors::CloseAfterPause}
    ], parser)
  end

  def test_should_map_string_port
    parser = Bane::ConfigurationParser.new("3000", IRRELEVANT_BEHAVIOR)
    assert_equal 3000, parser.configurations[0].port, "Should have mapped port given a String"
  end

  def test_should_raise_if_unknown_server_name
    assert_raises Bane::UnknownBehaviorError do
      Bane::ConfigurationParser.new(IRRELEVANT_PORT, "ABehaviorThatDoesNotExist")
    end
  end

  def test_should_map_server_when_given_class
    parser = ConfigurationParser.new(IRRELEVANT_PORT, Behaviors::CloseAfterPause)
    assert_equal Behaviors::CloseAfterPause, parser.configurations[0].behavior, "Wrong behavior"
  end

  def test_should_ask_service_registry_for_all_behaviors_if_none_specified
    fake_behavior = unique_behavior
    another_fake_behavior = unique_behavior

    ServiceRegistry.expects(:all_servers).returns([fake_behavior, another_fake_behavior])
    parser = ConfigurationParser.new(4000)
    assert_matches_configuration([
            {:port => 4000, :behavior => fake_behavior},
            {:port => 4001, :behavior => another_fake_behavior}
    ], parser)
  end

  def test_should_raise_exception_if_no_arguments
    assert_raises ConfigurationError do
      ConfigurationParser.new
    end
  end

  def test_should_raise_exception_if_nil_port_with_behaviors
    assert_raises ConfigurationError do
      ConfigurationParser.new(nil, IRRELEVANT_BEHAVIOR)
    end
  end

  def test_should_map_single_option_as_port_and_behavior
    parser = ConfigurationParser.new(
            10256 => Behaviors::CloseAfterPause
    )

    assert_matches_configuration([
            {:port => 10256, :behavior => Behaviors::CloseAfterPause}
    ], parser)
  end
  
  def test_should_map_multiple_options_as_port_and_behavior
    parser = ConfigurationParser.new(
            10256 => Behaviors::CloseAfterPause,
            6450 => Behaviors::CloseImmediately
    )

    assert_matches_configuration([
            {:port => 10256, :behavior => Behaviors::CloseAfterPause},
            {:port => 6450, :behavior => Behaviors::CloseImmediately}
    ], parser)
  end

  private

  def assert_matches_configuration(expected_config, actual_config)
    actual_elements = actual_config.configurations
    assert_equal expected_config.size, actual_elements.size, "Did not create correct number of configurations. Actual: #{actual_elements}, expected #{expected_config}"

    expected_config.each do |expected|
      # We make no guarantee on the order of the configurations
      matching_config = actual_elements.detect { |actual| actual.port == expected[:port]}
      assert_not_nil matching_config, "Should have found a configuration with port #{expected[:port]}"
      assert_equal expected[:behavior], matching_config.behavior, "Wrong behavior"
    end
  end

  def unique_behavior
    Module.new
  end

end