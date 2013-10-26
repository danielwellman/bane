require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'
require 'timeout'
require 'mocha/setup'

class BehaviorsTest < Test::Unit::TestCase

  include Bane::Behaviors

  def setup
    @fake_connection = FakeConnection.new
  end

  def test_fixed_response_sends_the_specified_message
    query_server(FixedResponse.new(message: "Test Message"))

    assert_equal "Test Message", response
  end

  def test_newline_response_sends_only_a_newline_character
    query_server(NewlineResponse.new)

    assert_equal "\n", response
  end

  def test_deluge_response_sends_one_million_bytes_by_default
    query_server(DelugeResponse.new)

    assert_response_length 1_000_000
  end

  def test_deluge_response_accepts_length_parameter
    query_server(DelugeResponse.new(length: 1))

    assert_response_length 1
  end

  def test_close_immediately_sends_no_response
    query_server(CloseImmediately.new)

    assert_empty_response()
  end

  def test_never_respond_never_sends_a_response
    server = NeverRespond.new

    assert_raise Timeout::Error do
      Timeout::timeout(1) { query_server(server) }
    end
    assert_empty_response
  end

  def test_close_after_pause_sleeps_30_seconds_by_default
    server = CloseAfterPause.new
    server.expects(:sleep).with(30)

    query_server(server)
  end


  def test_close_after_pause_accepts_duration_parameter
    server = CloseAfterPause.new(duration: 1)
    server.expects(:sleep).with(1)

    query_server(server)
  end

  def test_close_after_pause_sends_nothing
    server = CloseAfterPause.new
    server.stubs(:sleep)

    query_server(server)
  end

  def test_slow_response_sends_a_message_slowly
    message = "Hi!"
    delay = 0.5

    server = SlowResponse.new(pause_duration: delay, message: message)
    server.expects(:sleep).with(delay).at_least(message.length)

    query_server(server)

    assert_equal message, response
  end

  def test_random_response_sends_a_nonempty_response
    query_server(RandomResponse.new)

    assert (!response.empty?), "Should have served a nonempty response"
  end

  def test_refuse_all_http_credentials_sends_401_response_code
    @fake_connection.will_send("GET /some/irrelevant/path HTTP/1.1")

    server = HttpRefuseAllCredentials.new
    query_server(server)

    assert @fake_connection.read_all_queries?, "Should have read the HTTP query before sending response"
    assert_match /HTTP\/1.1 401 Unauthorized/, response, 'Should have responded with the 401 response code'
  end

  def test_for_each_line_reads_a_line_before_responding
    server = Bane::Behaviors::FixedResponseForEachLine.new({message: "Dynamic"})

    @fake_connection.will_send "irrelevant\n"

    query_server(server)
    assert_equal "Dynamic", response

    assert @fake_connection.read_all_queries?
  end

  private

  def query_server(server)
    server.serve(@fake_connection)
  end

  def response
    @fake_connection.string
  end

  def assert_empty_response
    assert_equal 0, response.length, "Should have sent nothing"
  end

  def assert_response_length(expected_length)
    assert_equal expected_length, response.length, "Response was the wrong length"
  end

end
