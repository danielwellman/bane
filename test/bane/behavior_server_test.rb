require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'
require 'mocha'

class BehaviorServerTest < Test::Unit::TestCase
  include Bane
  
  IRRELEVANT_IO_STREAM = nil
  IRRELEVANT_OPTIONS = {}
  IRRELEVANT_HOST = "1.1.1.1"
  IRRELEVANT_BEHAVIOR = nil

  def test_initializes_server_on_specified_port
    server = BehaviorServer.new(6000, IRRELEVANT_BEHAVIOR)
    assert_equal 6000, server.port
  end

  def test_initializes_server_on_specified_hostname
    server = BehaviorServer.new(IRRELEVANT_PORT, IRRELEVANT_BEHAVIOR, "hostname")
    assert_equal "hostname", server.host
  end

  def test_serve_passes_a_hash_of_options_even_if_not_initialized_with_options
    behavior = mock()
    server = BehaviorServer.new(IRRELEVANT_PORT, behavior)

    behavior.expects(:serve).with(anything(), is_a(Hash))

    server.serve(IRRELEVANT_IO_STREAM)
  end

  def test_serve_passes_constructor_options_to_behaviors_serve_method
    behavior = mock()
    
    initialized_options = {:expected => :options}
    server = BehaviorServer.new(IRRELEVANT_PORT, behavior, IRRELEVANT_HOST, initialized_options)

    behavior.expects(:serve).with(anything(), equals(initialized_options))

    server.serve(IRRELEVANT_IO_STREAM)
  end

  def test_connection_log_messages_use_short_behavior_name_to_shorten_log_messages
    [:connecting, :disconnecting].each do |method|
      assert_log_message_uses_short_behavior_name_for(method) do |server|
        server.send(method, stub_everything(:peeraddr => [127, 0, 0, 1]))
      end
    end
  end

  def test_start_stop_log_messages_use_short_behavior_name_to_shorten_log_messages
    [:starting, :stopping].each do |method|
      assert_log_message_uses_short_behavior_name_for(method) do |server|
        server.send(method)
      end
    end
  end

  def assert_log_message_uses_short_behavior_name_for(method)
    logger = StringIO.new
    server = BehaviorServer.new(IRRELEVANT_PORT, Bane::Behaviors::CloseImmediately.new)
    server.stdlog = logger
    
    yield server

    assert_match /CloseImmediately/, logger.string, "Log for #{method} should contain class short name"
    assert_no_match /Behaviors::CloseImmediately/, logger.string, "Log for #{method} should not contain expanded module name"
  end

end