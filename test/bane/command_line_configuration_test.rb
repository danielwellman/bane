require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'
require 'mocha/setup'

class CommandLineConfigurationTest < Test::Unit::TestCase
  include Bane

  IRRELEVANT_BEHAVIOR = 'CloseImmediately'

  # Creation tests (uses a cluster of objects starting at the top-level CommandLineConfiguration)

  def test_creates_specified_behavior_on_given_port
    expect_behavior_created_with(port: 3000, behavior: Behaviors::CloseImmediately)

    create_configuration_for([3000, 'CloseImmediately'])
  end

  def test_creates_multiple_behaviors_starting_on_given_port
    expect_behavior_created_with port: 3000, behavior: Behaviors::CloseImmediately
    expect_behavior_created_with port: 3001, behavior: Behaviors::CloseAfterPause

    create_configuration_for([3000, 'CloseImmediately', 'CloseAfterPause'])
  end

  def test_creates_all_known_behaviors_if_only_port_specified
    servers = create_configuration_for([IRRELEVANT_PORT])
    assert_equal (Behaviors::EXPORTED + Services::EXPORTED).size, servers.size,
                 "Expected to create many servers, but instead got #{servers}"
  end

  def test_creates_specified_service_on_given_port
    expect_service_created_with(port: 3000, service: Services::NeverListen)

    create_configuration_for([3000, 'NeverListen'])
  end



  def create_configuration_for(array)
    CommandLineConfiguration.new(mock('system adapter')).process(array)
  end

  def expect_behavior_created_with(arguments)
    behavior_matcher = instance_of(arguments.fetch(:behavior))
    port = arguments.fetch(:port)
    host = anything()
    Services::BehaviorServer.expects(:new).with(port, behavior_matcher, host).returns(Object.new)
  end

  def expect_service_created_with(arguments)
    service_class = arguments.fetch(:service)
    port = arguments.fetch(:port)
    service_class.expects(:new).with(port, anything()).returns(Object.new)
  end


  # Parsing arguments (uses the isolated ArgumentsParser object)

  def test_parses_the_port
    config = parse(["3000", IRRELEVANT_BEHAVIOR])
    assert_equal 3000, config.port
  end

  def test_parses_the_services
    config = parse([IRRELEVANT_PORT, 'NeverRespond', 'EchoResponse'])
    assert_equal ['NeverRespond', 'EchoResponse'], config.services
  end

  def test_host_defaults_to_localhost_if_not_specified
    config = parse([IRRELEVANT_PORT, IRRELEVANT_BEHAVIOR])
    assert_equal '127.0.0.1', config.host
  end

  def test_dash_l_option_sets_listen_host_to_localhost
    assert_parses_host(Services::DEFAULT_HOST, ['-l', IRRELEVANT_PORT, IRRELEVANT_BEHAVIOR])
  end

  def test_listen_on_localhost_sets_listen_host_to_localhost
    assert_parses_host(Services::DEFAULT_HOST, ['--listen-on-localhost', IRRELEVANT_PORT, IRRELEVANT_BEHAVIOR])
  end

  def test_dash_a_option_sets_listen_host_to_all_interfaces
    assert_parses_host(Services::ALL_INTERFACES, ['-a', IRRELEVANT_PORT, IRRELEVANT_BEHAVIOR])
  end

  def test_listen_on_all_hosts_option_sets_listen_host_to_all_interfaces
    assert_parses_host(Services::ALL_INTERFACES, ['--listen-on-all-hosts', IRRELEVANT_PORT, IRRELEVANT_BEHAVIOR])
  end


  def parse(arguments)
    ArgumentsParser.new.parse(arguments)
  end

  def assert_parses_host(expected_host, arguments)
    config = parse(arguments)
    assert_equal expected_host, config.host
  end


  # Failure tests (uses a cluster of objects starting at the top-level CommandLineConfiguration)

  def test_no_arguments_exits_with_success_and_usage
    failure_handler = mock()
    failure_handler.expects(:exit_success).with(regexp_matches(/usage/i))
    CommandLineConfiguration.new(failure_handler).process([])
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


  def assert_invalid_arguments_fail_matching_message(arguments, message_matcher)
    system = mock('system adapter')
    system.expects(:incorrect_usage).with(regexp_matches(message_matcher))
    CommandLineConfiguration.new(system).process(arguments)
  end


end
