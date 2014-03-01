require_relative '../../test_helper'

class EchoResponseTest < Test::Unit::TestCase

  include Bane::Behaviors
  include BehaviorTestHelpers

  def test_returns_received_characters
    fake_connection.will_send("Hello, echo!")

    query_server(EchoResponse.new)

    assert_equal "Hello, echo!", response
  end

end
