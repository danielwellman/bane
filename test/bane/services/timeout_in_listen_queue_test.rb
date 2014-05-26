require_relative '../../test_helper'
require 'socket'

class TimeoutInListenQueueTest < Test::Unit::TestCase

  include LaunchableRoleTests
  include ServerTestHelpers

  def setup
    @object = Bane::Services::TimeoutInListenQueue.make(IRRELEVANT_PORT, Bane::Services::LOCALHOST)
  end

  def test_never_connects
    run_server(Bane::Services::TimeoutInListenQueue.make(port, Bane::Services::LOCALHOST)) do
      assert_raise(Errno::ECONNREFUSED) { TCPSocket.new('localhost', port) }
    end
  end

  def port
    4001
  end

end
