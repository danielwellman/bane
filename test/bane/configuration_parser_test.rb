require File.dirname(__FILE__) + '/../test_helper'
require 'mocha'

class ConfigurationParserTest < Test::Unit::TestCase

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
    actual = parser.configurations[0]
    assert_equal 3000, actual.instance_variable_get(:@port), "Should have mapped port given a String"
  end

  def test_should_raise_if_unknown_server_name
    assert_raises Bane::UnknownBehaviorError do
      Bane::ConfigurationParser.new(IRRELEVANT_PORT, "ABehaviorThatDoesNotExist")
    end
  end

  def test_should_map_server_when_given_class
    parser = ConfigurationParser.new(IRRELEVANT_PORT, Behaviors::CloseAfterPause)
    actual = parser.configurations[0]
    assert_equal Behaviors::CloseAfterPause, actual.instance_variable_get(:@behavior), "Wrong behavior"
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

  def test_should_map_single_hash_entry_as_port_and_behavior
    parser = ConfigurationParser.new(
            10256 => Behaviors::CloseAfterPause
    )

    assert_matches_configuration([
            {:port => 10256, :behavior => Behaviors::CloseAfterPause}
    ], parser)
  end
  
  def test_should_map_multiple_hash_entries_as_port_and_behavior
    parser = ConfigurationParser.new(
            10256 => Behaviors::CloseAfterPause,
            6450 => Behaviors::CloseImmediately
    )

    assert_matches_configuration([
            {:port => 10256, :behavior => Behaviors::CloseAfterPause},
            {:port => 6450, :behavior => Behaviors::CloseImmediately}
    ], parser)
  end

  def test_should_map_hash_with_options
    parser = ConfigurationParser.new(
            10256 => {:behavior => Behaviors::CloseAfterPause, :duration => 3},
            11239 => Behaviors::CloseImmediately
    )
    
    assert_matches_configuration([
            {:port => 10256, :behavior => Behaviors::CloseAfterPause},
            {:port => 11239, :behavior => Behaviors::CloseImmediately}
    ], parser)
  end

  private

  def assert_matches_configuration(expected_config, actual_config)
    actual_elements = actual_config.configurations
    assert_equal expected_config.size, actual_elements.size, "Did not create correct number of configurations. Actual: #{actual_elements}, expected #{expected_config}"

    expected_config.each do |expected|
      # We make no guarantee on the order of the configurations
      assert_includes_configuration(actual_elements, expected)
    end
  end

  def assert_includes_configuration(actual_elements, expected)
    expected_port = expected[:port]
    matching_config = actual_elements.detect { |actual| actual.port == expected_port }
    assert_not_nil matching_config, "Should have found a configuration with port #{expected_port}"
    assert_equal expected[:behavior], matching_config.behavior, "Wrong behavior for port #{expected_port}"
  end

  def unique_behavior
    Module.new
  end

end