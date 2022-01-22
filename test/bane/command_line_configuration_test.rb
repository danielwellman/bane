# frozen_string_literal: true

require_relative '../test_helper'
require 'mocha/test_unit'

class CommandLineConfigurationTest < Test::Unit::TestCase
  include Bane

  # Creation tests (uses a cluster of objects starting at the top-level CommandLineConfiguration)

  def test_creates_specified_makeable_on_given_port
    behaviors = process arguments: [3000, 'ThingA'],
                       configuration: { 'ThingA' => SimpleMaker.new('ThingA'),
                                        'ThingB' => SimpleMaker.new('ThingB') }
    assert_equal 1, behaviors.size, "Wrong number of behaviors, got #{behaviors}"
    assert_makeable_created(behaviors.first, port: 3000, name: 'ThingA')
  end

  def test_creates_multiple_makeables_on_increasing_ports
    behaviors = process arguments: [4000, 'ThingA', 'ThingB'],
                       configuration: {'ThingA' => SimpleMaker.new('ThingA'),
                                       'ThingB' => SimpleMaker.new('ThingB') }

    assert_equal 2, behaviors.size, "Wrong number of behaviors, got #{behaviors}"
    assert_makeable_created(behaviors.first, port: 4000, name: 'ThingA')
    assert_makeable_created(behaviors.last, port: 4000 + 1, name: 'ThingB')
  end

  def test_creates_all_known_makeables_in_alphabetical_order_if_only_port_specified
    behaviors = process arguments: [4000],
                       configuration: { 'ThingB' => SimpleMaker.new('ThingB'),
                                        'ThingC' => SimpleMaker.new('ThingC'),
                                        'ThingA' => SimpleMaker.new('ThingA') }

    assert_equal 3, behaviors.size, "Wrong number of behaviors created, got #{behaviors}"
    assert_equal 'ThingA', behaviors[0].name
    assert_equal 'ThingB', behaviors[1].name
    assert_equal 'ThingC', behaviors[2].name
  end

  def process(options)
    arguments = options.fetch(:arguments)
    makeables = options.fetch(:configuration)
    CommandLineConfiguration.new(makeables).process(arguments) { |errors| raise errors }
  end

  def assert_makeable_created(behaviors, parameters)
    assert_equal parameters.fetch(:port), behaviors.port
    assert_equal parameters.fetch(:name), behaviors.name
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

  def test_unknown_behavior_fails_with_message
    assert_invalid_arguments_fail_matching_message([IRRELEVANT_PORT, 'AnUnknownBehavior'], /Unknown Behavior/i)
  end

  def test_invalid_option_fails_with_error_message
    assert_invalid_arguments_fail_matching_message(['--unknown-option', IRRELEVANT_PORT], /Invalid Option/i)
  end

  def assert_invalid_arguments_fail_matching_message(arguments, message_matcher)
    block_called = false
    CommandLineConfiguration.new({}).process(arguments) do |error_message|
      block_called = true
      assert_match message_matcher, error_message
    end
    assert block_called, "Expected invalid arguments to invoke the failure block"
  end

end
