require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'
require 'mocha/setup'

class CommandLineConfigurationTest < Test::Unit::TestCase
  include Bane

  IRRELEVANT_BEHAVIOR = 'CloseImmediately'

  def test_creates_specified_behavior_on_given_port
    expect_behavior_created_with(port: 3000, behavior: Behaviors::CloseImmediately)

    create_configuration_for([3000, 'CloseImmediately'])
  end

  def test_creates_multiple_behaviors_starting_on_given_port
    expect_behavior_created_with port: 3000, behavior: Behaviors::CloseImmediately
    expect_behavior_created_with port: 3001, behavior: Behaviors::CloseAfterPause

    create_configuration_for([3000, 'CloseImmediately', 'CloseAfterPause'])
  end

  def test_creates_all_known_behavior_if_only_port_specified
    servers = create_configuration_for([4000])
    assert servers.size > 1, "Expected to create many servers, but instead got #{servers}"
  end

  def test_creates_specified_service_on_given_port
    expect_service_created_with(port: 3000, service: Services::NeverListen)

    create_configuration_for([3000, 'NeverListen'])
  end



  def test_dash_l_option_sets_listen_host_to_localhost
    expect_behavior_created_with host: Services::DEFAULT_HOST

    create_configuration_for(['-l', IRRELEVANT_PORT, IRRELEVANT_BEHAVIOR])
  end

  def test_listen_on_localhost_sets_listen_host_to_localhost
    expect_behavior_created_with host: Services::DEFAULT_HOST

    create_configuration_for(['--listen-on-localhost', IRRELEVANT_PORT, IRRELEVANT_BEHAVIOR])
  end

  def test_dash_a_option_sets_listen_host_to_all_interfaces
    expect_behavior_created_with host: Services::ALL_INTERFACES

    create_configuration_for(['-a', IRRELEVANT_PORT, IRRELEVANT_BEHAVIOR])
  end

  def test_listen_on_all_hosts_option_sets_listen_host_to_all_interfaces
    expect_behavior_created_with host: Services::ALL_INTERFACES

    create_configuration_for(['--listen-on-all-hosts', IRRELEVANT_PORT, IRRELEVANT_BEHAVIOR])
  end


  def test_no_arguments_exits_with_success_and_usage
    failure_handler = mock()
    failure_handler.expects(:exit_success).with(regexp_matches(/usage/i))
    CommandLineConfiguration.new(failure_handler).parse([])
  end



  def test_non_integer_port_fails_with_error_message
    assert_invalid_arguments_fail_matching_message(['text_instead_of_an_integer'], /Invalid Port Number/i)
  end

  def test_unknown_service_fails_with_message
    assert_invalid_arguments_fail_matching_message([IRRELEVANT_PORT, 'AnUnknownService'], /Unknown Service/i)
  end

  def test_invalid_option_fails_with_error_message
    assert_invalid_arguments_fail_matching_message(['--unknown-option', IRRELEVANT_PORT], /Invalid Option/i)
  end


  private

  def create_configuration_for(array)
    CommandLineConfiguration.new(mock('system adapter')).parse(array)
  end

  def expect_behavior_created_with(arguments)
    arguments = {port: anything(), host: anything()}.merge(arguments)
    behavior_matcher = arguments[:behavior] ? instance_of(arguments[:behavior]) : anything()
    Services::BehaviorServer.expects(:new).with(arguments[:port], behavior_matcher, arguments[:host]).returns(Object.new)
  end

  def expect_service_created_with(arguments)
    service_class = arguments.fetch(:service)
    port = arguments.fetch(:port)
    service_class.expects(:new).with(port, anything()).returns(Object.new)
  end

  def assert_invalid_arguments_fail_matching_message(arguments, message_matcher)
    system = mock('system adapter')
    system.expects(:incorrect_usage).with(regexp_matches(message_matcher))
    CommandLineConfiguration.new(system).parse(arguments)
  end


end
