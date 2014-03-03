require_relative '../../test_helper'
require 'socket'

class NeverListenTest < Test::Unit::TestCase

  include LaunchableRoleTests

  def setup
    @object = Bane::Services::NeverListen.make(IRRELEVANT_PORT, Bane::Services::LOCALHOST)
  end

  def test_never_connects
    service = Bane::Services::NeverListen.make(port, Bane::Services::LOCALHOST)
    service.stdlog = StringIO.new
    service.start

    assert_raise(Errno::ECONNREFUSED) {
      TCPSocket.new('localhost', port)
    }
  ensure
    service.stop
  end

  def port
    4001
  end

end
