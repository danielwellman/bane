require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'
require 'mocha/setup'

class SlowResponseTest < Test::Unit::TestCase

  include Bane::Behaviors
  include BehaviorTestHelpers

  def test_pauses_between_sending_each_character
    message = "Hi!"
    delay = 0.5

    server = SlowResponse.new(pause_duration: delay, message: message)
    server.expects(:sleep).with(delay).at_least(message.length)

    query_server(server)

    assert_equal message, response
  end

end
