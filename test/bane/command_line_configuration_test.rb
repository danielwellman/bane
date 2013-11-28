require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'
require 'mocha/setup'

class CommandLineConfigurationTest < Test::Unit::TestCase
  include Bane

  # Creation tests (uses a cluster of objects starting at the top-level CommandLineConfiguration)

  def test_creates_specified_makeable_on_given_port
    services = configuration_with_makeables({'ThingA' => SimpleMaker.new('ThingA'),
                                             'ThingB' => SimpleMaker.new('ThingB')
                                            }).process([3000, 'ThingA'])

    assert_equal 1, services.size, "Wrong number of services, got #{services}"
    assert_makeable_created(services.first, port: 3000, name: 'ThingA')
  end

  def test_creates_multiple_makeables_on_increasing_ports
    services = configuration_with_makeables({'ThingA' => SimpleMaker.new('ThingA'),
                                             'ThingB' => SimpleMaker.new('ThingB')
                                            }).process([4000, 'ThingA', 'ThingB'])

    assert_equal 2, services.size, "Wrong number of services, got #{services}"
    assert_makeable_created(services.first, port: 4000, name: 'ThingA')
    assert_makeable_created(services.last, port: 4000 + 1, name: 'ThingB')
  end

  def test_creates_all_known_makeables_if_only_port_specified
    services = configuration_with_makeables({
            'ThingA' => SimpleMaker.new('ThingA'),
            'ThingB' => SimpleMaker.new('ThingB'),
            'ThingC' => SimpleMaker.new('ThingC')
    }).process([4000])

    assert_equal 3, services.size, "Wrong number of services created, got #{services}"
  end

  def configuration_with_makeables(makeables_map)
    CommandLineConfiguration.new(mock('system adapter'), makeables_map)
  end

  def assert_makeable_created(services, parameters)
    assert_equal parameters.fetch(:port), services.port
    assert_equal parameters.fetch(:name), services.name
  end

  class SimpleMaker
    attr_reader :name, :port, :host
    def initialize(name)
      @name = name
    end

    def make(port, host)
      @port = port
      @host = host
      self
    end
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
    CommandLineConfiguration.new(system, {}).process(arguments)
  end


end
