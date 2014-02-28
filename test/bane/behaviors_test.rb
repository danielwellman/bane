require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'
require 'mocha/setup'

class BehaviorsTest < Test::Unit::TestCase

  include Bane::Behaviors
  include BehaviorTestHelpers

  def test_deluge_response_sends_one_million_bytes_by_default
    query_server(DelugeResponse.new)

    assert_response_length 1_000_000
  end

  def test_deluge_response_accepts_length_parameter
    query_server(DelugeResponse.new(length: 1))

    assert_response_length 1
  end

  def test_refuse_all_http_credentials_sends_401_response_code
    fake_connection.will_send("GET /some/irrelevant/path HTTP/1.1")

    server = HttpRefuseAllCredentials.new
    query_server(server)

    assert fake_connection.read_all_queries?, "Should have read the HTTP query before sending response"
    assert_match /HTTP\/1.1 401 Unauthorized/, response, 'Should have responded with the 401 response code'
  end

  def test_echo_response_returns_received_characters
    fake_connection.will_send("Hello, echo!")

    query_server(EchoResponse.new)

    assert_equal "Hello, echo!", response
  end

  def test_for_each_line_reads_a_line_before_responding
    server = Bane::Behaviors::FixedResponseForEachLine.new({message: "Dynamic"})

    fake_connection.will_send "irrelevant\n"

    query_server(server)
    assert_equal "Dynamic", response

    assert fake_connection.read_all_queries?
  end

end
