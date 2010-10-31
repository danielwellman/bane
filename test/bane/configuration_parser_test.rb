require File.dirname(__FILE__) + '/../test_helper'
require 'mocha'

class ConfigurationParserTest < Test::Unit::TestCase

  include Bane

  IRRELEVANT_BEHAVIOR = Bane::Behaviors::CloseImmediately

  def test_should_map_single_port_and_server_name
    expect_server_created_with :port => 3000, :behavior => Behaviors::CloseAfterPause

    ConfigurationParser.new(3000, "CloseAfterPause")
  end

  def test_should_map_multiple_servers_given_one_starting_port
    expect_server_created_with :port => 3000, :behavior => Behaviors::CloseImmediately
    expect_server_created_with :port => 3001, :behavior => Behaviors::CloseAfterPause

    ConfigurationParser.new(3000, "CloseImmediately", "CloseAfterPause")
  end

  def test_should_map_string_port
    expect_server_created_with :port => 3000, :behavior => IRRELEVANT_BEHAVIOR
    
    Bane::ConfigurationParser.new("3000", IRRELEVANT_BEHAVIOR)
  end

  def test_should_raise_if_unknown_server_name
    assert_raises Bane::UnknownBehaviorError do
      Bane::ConfigurationParser.new(IRRELEVANT_PORT, "ABehaviorThatDoesNotExist")
    end
  end

  def test_should_map_server_when_given_class
    expect_server_created_with :port => anything(), :behavior => Behaviors::CloseAfterPause

    ConfigurationParser.new(IRRELEVANT_PORT, Behaviors::CloseAfterPause)
  end

  def test_should_ask_service_registry_for_all_behaviors_if_none_specified
    fake_behavior = unique_behavior
    another_fake_behavior = unique_behavior

    expect_server_created_with :port => anything(), :behavior => fake_behavior
    expect_server_created_with :port => anything(), :behavior => another_fake_behavior

    ServiceRegistry.expects(:all_servers).returns([fake_behavior, another_fake_behavior])
    ConfigurationParser.new(4000)
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
    expect_server_created_with :port => 10256, :behavior => Behaviors::CloseAfterPause

    ConfigurationParser.new(
            10256 => Behaviors::CloseAfterPause
    )
  end
  
  def test_should_map_multiple_hash_entries_as_port_and_behavior
    expect_server_created_with :port => 10256, :behavior => Behaviors::CloseAfterPause
    expect_server_created_with :port => 6450, :behavior => Behaviors::CloseImmediately

    ConfigurationParser.new(
            10256 => Behaviors::CloseAfterPause,
            6450 => Behaviors::CloseImmediately
    )
  end

  def test_should_map_hash_with_options
    expect_server_created_with :port => 10256, :behavior => Behaviors::CloseAfterPause, :options => { :duration => 3 }
    expect_server_created_with :port => 11239, :behavior => Behaviors::CloseImmediately

    ConfigurationParser.new(
            10256 => {:behavior => Behaviors::CloseAfterPause, :duration => 3},
            11239 => Behaviors::CloseImmediately
    )
  end

  private

  def expect_server_created_with(arguments)
    arguments = { :options => anything() }.merge(arguments)
    BehaviorServer.expects(:new).with(arguments[:port], instance_of(arguments[:behavior]), arguments[:options])
  end

  
  def unique_behavior
    Class.new
  end

end