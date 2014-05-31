require_relative '../../../test_helper'

class NeverRespondTest < Test::Unit::TestCase

  include Bane::Behaviors::Responders
  include BehaviorTestHelpers
  include ServerTestHelpers

  LONG_MESSAGE = 'x'*(1024*5)

  def test_does_not_send_a_response
    server = NeverRespond.new

    query_server(server)
    assert_empty_response
  end

  def test_disconnects_after_client_closes_connection
    run_server(Bane::Services::ResponderServer.new(0, NeverRespond.new)) do |server|
      client = TCPSocket.new('localhost', server.port)
      sleep 3
      client.write LONG_MESSAGE
      client.close

      sleep 0.1

      assert_equal 0, server.connections
    end
  end

end
