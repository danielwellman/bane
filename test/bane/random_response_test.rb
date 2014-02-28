require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

class RandomResponseTest < Test::Unit::TestCase

  include Bane::Behaviors
  include BehaviorTestHelpers

  def test_sends_a_nonempty_response
    query_server(RandomResponse.new)

    assert (!response.empty?), "Should have served a nonempty response"
  end

end

