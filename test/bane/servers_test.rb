require File.dirname(__FILE__) + '/../test_helper'
require 'timeout'

class ServersTest < Test::Unit::TestCase

  def setup
    @fake_connection = StringIO.new
  end

  def test_deluge_response_sends_lots_of_data
    query_server(create Bane::DelugeResponse)

    assert_equal 1_000_000, response.length, "Should have been a large response"
  end

  def test_close_immediately_sends_no_response
    query_server(create Bane::CloseImmediately)

    assert_empty_response()
  end

  def test_never_respond_never_sends_a_response
    server = create Bane::NeverRespond

    assert_raise Timeout::Error do
      Timeout::timeout(3) { query_server(server) }
    end
    assert_empty_response
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

  def create(server_class)
    irrelevant_port = 125873
    server_class.new(irrelevant_port)
  end

end