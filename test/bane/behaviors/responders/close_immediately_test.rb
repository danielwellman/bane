require_relative '../../../test_helper'

class CloseImmediatelyTest < Test::Unit::TestCase

  include Bane::Behaviors::Responders
  include BehaviorTestHelpers

  def test_sends_no_response
    query_server(CloseImmediately.new)

    assert_empty_response
  end

end