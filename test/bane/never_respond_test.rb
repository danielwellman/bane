require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

class NeverRespondTest < Test::Unit::TestCase

  include Bane::Behaviors
  include BehaviorTestHelpers

  def test_never_sends_a_response
    server = NeverRespond.new

    assert_times_out { query_server(server) }
    assert_empty_response
  end

end
