# frozen_string_literal: true

require_relative '../../../test_helper'

class RandomResponseTest < Test::Unit::TestCase

  include Bane::Behaviors::Responders
  include BehaviorTestHelpers

  def test_sends_a_nonempty_response
    query_server(RandomResponse.new)

    assert (!response.empty?), "Should have served a nonempty response"
  end

end

