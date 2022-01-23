# frozen_string_literal: true

require_relative '../../../test_helper'
require 'socket'

class TimeoutInListenQueueTest < Test::Unit::TestCase

  include LaunchableRoleTests
  include ServerTestHelpers

  def setup
    @object = Bane::Behaviors::Servers::TimeoutInListenQueue.make(IRRELEVANT_PORT, Bane::Behaviors::Servers::LOCALHOST)
  end

  def test_never_connects
    run_server(Bane::Behaviors::Servers::TimeoutInListenQueue.make(port, Bane::Behaviors::Servers::LOCALHOST)) do
      assert_raise(Errno::ECONNREFUSED) { TCPSocket.new('localhost', port) }
    end
  end

  def port
    4001
  end

end
