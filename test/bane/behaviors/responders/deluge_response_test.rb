require_relative '../../../test_helper'

class DelugeResponseTest < Test::Unit::TestCase

  include Bane::Behaviors::Responders
  include BehaviorTestHelpers

  def test_sends_one_million_bytes_by_default
    query_server(DelugeResponse.new)

    assert_response_length 1_000_000
  end

  def test_sends_the_specified_number_of_bytes
    query_server(DelugeResponse.new(length: 1))

    assert_response_length 1
  end

end
