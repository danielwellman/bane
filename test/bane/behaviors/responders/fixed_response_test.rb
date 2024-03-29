# frozen_string_literal: true

require_relative '../../../test_helper'

class FixedResponseTest < Test::Unit::TestCase

  include Bane::Behaviors::Responders
  include BehaviorTestHelpers

  def test_sends_the_specified_message
    query_server(FixedResponse.new(message: "Test Message"))

    assert_equal "Test Message", response
  end

end
