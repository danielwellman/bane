require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

class CloseImmediatelyTest < Test::Unit::TestCase

  include Bane::Behaviors
  include BehaviorTestHelpers

  def test_sends_no_response
    query_server(CloseImmediately.new)

    assert_empty_response
  end

end