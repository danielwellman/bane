require File.dirname(__FILE__) + '/../test_helper'
require 'mocha'

class ConfigurationTest < Test::Unit::TestCase

  include Bane

  def test_should_map_string_port
    configuration = Bane::Configuration.new("3000", "CloseAfterPause")
    assert_matches_configuration([
            {:port => 3000, :behavior => Behaviors::CloseAfterPause}
    ], configuration)
  end

  def test_should_raise_if_unknown_server_name
    assert_raises Bane::UnknownBehaviorError do
      Bane::Configuration.new(IRRELEVANT_PORT, "ABehaviorThatDoesNotExist")
    end
  end

  def test_should_map_single_port_and_server_name
    configuration = Bane::Configuration.new(3000, "CloseAfterPause")
    assert_matches_configuration([
            {:port => 3000, :behavior => Behaviors::CloseAfterPause}
    ], configuration)
  end

  def test_should_map_server_when_given_class
    configuration = Bane::Configuration.new(3000, Behaviors::CloseAfterPause)
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

  def test_should_ask_service_registry_for_all_behaviors_if_none_specified
    fake_behavior = a_behavior()
    another_fake_behavior = a_behavior

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
      Configuration.new(nil, a_behavior)
    end
  end

  def test_should_map_single_options_as_port_and_behavior
    configuration = Configuration.new(
            10256 => Behaviors::CloseAfterPause
    )

    assert_matches_configuration([
            {:port => 10256, :behavior => Behaviors::CloseAfterPause}
    ], configuration)
  end

  private

  def assert_matches_configuration(expected_config, actual_config)
    actual_elements = actual_config.to_a
    assert_equal expected_config.size, actual_elements.size, "Did not create correct number of configurations. Actual: #{actual_elements}, expected #{expected_config}"

    expected_config.each_with_index do |expected, index|
      assert_equal expected[:port], actual_elements[index][0], "Wrong port"
      assert_equal expected[:behavior], actual_elements[index][1], "Wrong behavior"
    end
  end

  def a_behavior
    Module.new
  end

end