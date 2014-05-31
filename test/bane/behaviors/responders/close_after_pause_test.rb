require_relative '../../../test_helper'
require 'mocha/setup'

class CloseAfterPauseTest < Test::Unit::TestCase

  include Bane::Behaviors::Responders
  include BehaviorTestHelpers

  def test_sleeps_30_seconds_by_default
    server = CloseAfterPause.new
    server.expects(:sleep).with(30)

    query_server(server)
  end

  def test_sleeps_specified_number_of_seconds
    server = CloseAfterPause.new(duration: 1)
    server.expects(:sleep).with(1)

    query_server(server)
  end

  def test_sends_nothing
    server = CloseAfterPause.new
    server.stubs(:sleep)

    query_server(server)
  end

end