require File.dirname(__FILE__) + '/../test_helper'
require 'timeout'
require 'mocha'

class BehaviorsTest < Test::Unit::TestCase

  include Bane::Behaviors

  def setup
    @fake_connection = StringIO.new
  end

  def test_deluge_response_sends_one_million_bytes_by_default
    query_server(create DelugeResponse)

    assert_response_length 1_000_000
  end

  def test_deluge_response_accepts_length_parameter
    query_server(create(DelugeResponse), :length => 1)

    assert_response_length 1
  end

  def test_close_immediately_sends_no_response
    query_server(create CloseImmediately)

    assert_empty_response()
  end

  def test_never_respond_never_sends_a_response
    server = create NeverRespond

    assert_raise Timeout::Error do
      Timeout::timeout(3) { query_server(server) }
    end
    assert_empty_response
  end

  def test_close_after_pause_sleeps_30_seconds_by_default_and_sends_nothing
    server = create CloseAfterPause
    server.expects(:sleep).with(30)
    
    query_server(server)

    assert_empty_response
  end

  def test_close_after_pause_accepts_duration_parameter
    server = create CloseAfterPause

    within(2) { query_server(server, :duration => 1) }
  end

  def test_slow_response_sends_a_message_slowly
    server = create SlowResponse
    message = "Hi!"
    delay = 1
    max_delay = (message.length + 1) * delay

    within(max_delay) { query_server(server, :pause_duration => delay, :message => message)}

    assert_equal message, response
  end

  def test_random_response_sends_a_nonempty_response
    query_server(create RandomResponse)

    assert (!response.empty?), "Should have served a nonempty response"
  end

  private

  def create(server_class)
    server_class.new()
  end

  def query_server(server, options = {})
    server.serve(@fake_connection, options)
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

  def within(duration)
    begin
      Timeout::timeout(duration) { yield }
    rescue Timeout::Error
      flunk "Test took too long - should have completed within #{duration} seconds."
    end
  end

end