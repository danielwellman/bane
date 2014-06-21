require_relative '../../../test_helper'

class NewlineResponseTest < Test::Unit::TestCase

  include Bane::Behaviors::Responders
  include BehaviorTestHelpers

  def test_sends_only_a_newline_character
    query_server(NewlineResponse.new)

    assert_equal "\n", response
  end

end
