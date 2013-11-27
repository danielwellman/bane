require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'
require 'mocha/setup'

class CommandLineConfigurationTest < Test::Unit::TestCase
  include Bane

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
    host = anything
    Services::BehaviorServer.expects(:new).with(port, behavior_matcher, host).returns(Object.new)
  end

  def expect_service_created_with(arguments)
    service_class = arguments.fetch(:service)
    port = arguments.fetch(:port)
    service_class.expects(:new).with(port, anything).returns(Object.new)
  end

  # Failure tests (uses a cluster of objects starting at the top-level CommandLineConfiguration)

  def test_unknown_service_fails_with_message
    assert_invalid_arguments_fail_matching_message([IRRELEVANT_PORT, 'AnUnknownService'], /Unknown Service/i)
  end

  def test_invalid_option_fails_with_error_message
    assert_invalid_arguments_fail_matching_message(['--unknown-option', IRRELEVANT_PORT], /Invalid Option/i)
  end

  # TODO I probably want to live somewhere else
  def test_includes_behaviors_and_services_in_all_makeables
    all_names = Bane.find_makeables.keys

    assert all_names.include?('NeverRespond'), "Expected 'NeverRespond' behavior to be in #{all_names}"
    assert all_names.include?('NeverListen'), "Expected 'NeverRespond' service to be in #{all_names}"
  end

  def assert_invalid_arguments_fail_matching_message(arguments, message_matcher)
    system = mock('system adapter')
    system.expects(:incorrect_usage).with(regexp_matches(message_matcher))
    CommandLineConfiguration.new(system).process(arguments)
  end


end
