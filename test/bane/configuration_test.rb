require File.dirname(__FILE__) + '/../test_helper'
require 'mocha'

class ConfigurationTest < Test::Unit::TestCase

  include Bane

  IRRELEVANT_BEHAVIOR = Module.new

  def test_should_map_single_port_and_server_name
    configuration = Bane::Configuration.new(3000, "CloseAfterPause")
    assert_matches_configuration([
            {:port => 3000, :behavior => Behaviors::CloseAfterPause}
    ], configuration)
  end

  def test_should_map_multiple_servers_given_one_starting_port
    configuration = Configuration.new(3000, "CloseImmediately", "CloseAfterPause")
    assert_matches_configuration([
            {:port => 3000, :behavior => Behaviors::CloseImmediately},
            {:port => 3001, :behavior => Behaviors::CloseAfterPause}
    ], configuration)
  end

  def test_should_map_string_port
    configuration = Bane::Configuration.new("3000", IRRELEVANT_BEHAVIOR)
    assert_equal 3000, configuration.to_a[0][0], "Should have mapped port given a String"
  end

  def test_should_raise_if_unknown_server_name
    assert_raises Bane::UnknownBehaviorError do
      Bane::Configuration.new(IRRELEVANT_PORT, "ABehaviorThatDoesNotExist")
    end
  end

  def test_should_map_server_when_given_class
    configuration = Bane::Configuration.new(IRRELEVANT_PORT, Behaviors::CloseAfterPause)
    assert_equal Behaviors::CloseAfterPause, configuration.to_a[0][1], "Wrong behavior"
  end

  def test_should_ask_service_registry_for_all_behaviors_if_none_specified
    fake_behavior = unique_behavior
    another_fake_behavior = unique_behavior

    ServiceRegistry.expects(:all_servers).returns([fake_behavior, another_fake_behavior])
    configuration = Configuration.new(4000)
    assert_matches_configuration([
            {:port => 4000, :behavior => fake_behavior},
            {:port => 4001, :behavior => another_fake_behavior}
    ], configuration)
  end

  def test_should_raise_exception_if_no_arguments
    assert_raises ConfigurationError do
      Configuration.new
    end
  end

  def test_should_raise_exception_if_nil_port_with_behaviors
    assert_raises ConfigurationError do
      Configuration.new(nil, IRRELEVANT_BEHAVIOR)
    end
  end

  def test_should_map_single_option_as_port_and_behavior
    configuration = Configuration.new(
            10256 => Behaviors::CloseAfterPause
    )

    assert_matches_configuration([
            {:port => 10256, :behavior => Behaviors::CloseAfterPause}
    ], configuration)
  end
  
  def test_should_map_multiple_options_as_port_and_behavior
    configuration = Configuration.new(
            10256 => Behaviors::CloseAfterPause,
            6450 => Behaviors::CloseImmediately
    )

    assert_matches_configuration([
            {:port => 10256, :behavior => Behaviors::CloseAfterPause},
            {:port => 6450, :behavior => Behaviors::CloseImmediately}
    ], configuration)
  end

  private

  def assert_matches_configuration(expected_config, actual_config)
    actual_elements = actual_config.to_a
    assert_equal expected_config.size, actual_elements.size, "Did not create correct number of configurations. Actual: #{actual_elements}, expected #{expected_config}"

    expected_config.each do |expected|
      # We make no guarantee on the order of the configurations
      matching_config = actual_elements.detect { |actual| actual[0] == expected[:port]}
      assert_not_nil matching_config, "Should have found a configuration with port #{expected[:port]}"
      assert_equal expected[:behavior], matching_config[1], "Wrong behavior"
    end
  end

  def unique_behavior
    Module.new
  end

end