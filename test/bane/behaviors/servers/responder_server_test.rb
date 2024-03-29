# frozen_string_literal: true

require_relative '../../../test_helper'
require 'mocha/test_unit'

class ResponderServerTest < Test::Unit::TestCase
  include LaunchableRoleTests

  include Bane
  include Bane::Behaviors::Servers

  IRRELEVANT_IO_STREAM = nil
  IRRELEVANT_OPTIONS = {}
  IRRELEVANT_HOST = '1.1.1.1'

  def setup
    @object = ResponderServer.new(IRRELEVANT_PORT, IRRELEVANT_BEHAVIOR)
  end

  def test_initializes_server_on_specified_port
    server = ResponderServer.new(6000, IRRELEVANT_BEHAVIOR)
    assert_equal 6000, server.port
  end

  def test_initializes_server_on_specified_hostname
    server = ResponderServer.new(IRRELEVANT_PORT, IRRELEVANT_BEHAVIOR, 'hostname')
    assert_equal 'hostname', server.host
  end

  def test_delegates_serve_call_to_responder
    io = mock
    responder = mock
    server = ResponderServer.new(IRRELEVANT_PORT, responder)

    responder.expects(:serve).with(io)

    server.serve(io)
  end

  def test_connection_log_messages_use_short_behavior_name_to_shorten_log_messages
    [:connecting, :disconnecting].each do |method|
      assert_log_message_uses_short_behavior_name_for(method) do |server|
        server.send(method, stub_everything(peeraddr: [127, 0, 0, 1]))
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
    server = ResponderServer.new(IRRELEVANT_PORT, Bane::Behaviors::Responders::SampleForTesting.new)
    server.stdlog = logger

    yield server

    assert_match(/SampleForTesting/, logger.string, "Log for #{method} should contain class short name")
    assert_no_match(/Behaviors::Responders::SampleForTesting/, logger.string, "Log for #{method} should not contain expanded module name")
  end

end

module Bane
  module Behaviors
    module Responders
      class SampleForTesting
        def serve(io)
          io.puts('Hello')
        end
      end
    end
  end
end
