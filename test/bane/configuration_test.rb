require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'
require 'mocha'

class ConfigurationTest < Test::Unit::TestCase
  include Bane

  IRRELEVANT_BEHAVIOR = "CloseImmediately"

  def test_creates_specified_behavior_on_given_port
    expect_server_created_with(:port => 3000, :behavior => Behaviors::CloseImmediately)

    create_configuration_for([3000, "CloseImmediately"])
  end

  def test_creates_all_known_behavior_if_only_port_specified
    first_behavior = unique_behavior
    second_behavior = unique_behavior

    expect_server_created_with :port => 4000, :behavior => first_behavior
    expect_server_created_with :port => 4001, :behavior => second_behavior

    ServiceRegistry.stubs(:all_servers).returns([first_behavior, second_behavior])

    create_configuration_for([4000])
  end

  def test_creates_multiple_behaviors_starting_on_given_port
    expect_server_created_with :port => 3000, :behavior => Behaviors::CloseImmediately
    expect_server_created_with :port => 3001, :behavior => Behaviors::CloseAfterPause

    create_configuration_for([3000, "CloseImmediately", "CloseAfterPause"])
  end

  def test_dash_l_option_sets_listen_host_to_localhost
    expect_server_created_with :host => BehaviorServer::DEFAULT_HOST

    create_configuration_for(["-l", IRRELEVANT_PORT, IRRELEVANT_BEHAVIOR])
  end

  def test_listen_on_localhost_sets_listen_host_to_localhost
    expect_server_created_with :host => BehaviorServer::DEFAULT_HOST

    create_configuration_for(["--listen-on-localhost", IRRELEVANT_PORT, IRRELEVANT_BEHAVIOR])
  end

  def test_dash_a_option_sets_listen_host_to_all_interfaces
    expect_server_created_with :host => BehaviorServer::ALL_INTERFACES

    create_configuration_for(["-a", IRRELEVANT_PORT, IRRELEVANT_BEHAVIOR])
  end

  def test_listen_on_all_hosts_option_sets_listen_host_to_all_interfaces
    expect_server_created_with :host => BehaviorServer::ALL_INTERFACES

    create_configuration_for(["--listen-on-all-hosts", IRRELEVANT_PORT, IRRELEVANT_BEHAVIOR])
  end

  def test_no_arguments_returns_nil_configuration
    assert_equal(nil, Configuration.new([]).parse,
      "Should have returned no configurations for empty arguments")
  end

  def test_non_integer_port_fails_with_error_message
    assert_invaild_arguments_fail_matching_message(["text_instead_of_an_integer"], /Invalid Port Number/i,
      "Should have indicated the port was invalid.")
  end

  def test_unknown_behavior_fails_with_unknown_behavior_message
    assert_invaild_arguments_fail_matching_message([IRRELEVANT_PORT, "AnUknownBehavior"], /Unknown Behavior/i,
      "Should have indicated the given behavior is unknown.")
  end

  def test_invalid_option_fails_with_error_message
    assert_invaild_arguments_fail_matching_message(["--unknown-option", IRRELEVANT_PORT], /Invalid Option/i,
      "Should have indicated the --uknown-option switch was unknown.")
  end


  private

  def create_configuration_for(array)
    config = Configuration.new(array).parse
    config.servers
  end

  def unique_behavior
    Class.new
  end

  def expect_server_created_with(arguments)
    arguments = { :port => anything(), :host => anything() }.merge(arguments)
    behavior_matcher = arguments[:behavior] ? instance_of(arguments[:behavior]) : anything()
    BehaviorServer.expects(:new).with(arguments[:port], arguments[:host], 
      behavior_matcher)
  end

  def assert_invaild_arguments_fail_matching_message(arguments, message_matcher, assertion_failure_message)
    Configuration.new(arguments).parse
    fail "Should have failed"
    rescue ConfigurationError => ce
      assert_match(message_matcher, ce.message, assertion_failure_message)
  end


end
