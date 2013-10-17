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

  def test_delegates_serve_call_to_behavior
    io = mock()
    behavior = mock()
    server = BehaviorServer.new(IRRELEVANT_PORT, behavior)

    behavior.expects(:serve).with(io)

    server.serve(io)
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
    server = BehaviorServer.new(IRRELEVANT_PORT, Bane::Behaviors::SampleForTesting.new)
    server.stdlog = logger
    
    yield server

    assert_match /SampleForTesting/, logger.string, "Log for #{method} should contain class short name"
    assert_no_match /Behaviors::SampleForTesting/, logger.string, "Log for #{method} should not contain expanded module name"
  end

end

module Bane
  module Behaviors
    class SampleForTesting < Bane::Behaviors::BasicBehavior
      def serve(io)
        io.puts('Hello')
      end
    end
  end
end
