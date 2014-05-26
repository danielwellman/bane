require_relative '../../test_helper'
require 'socket'

class NeverListenTest < Test::Unit::TestCase

  include LaunchableRoleTests
  include ServerTestHelpers

  def setup
    @object = Bane::Services::NeverListen.make(IRRELEVANT_PORT, Bane::Services::LOCALHOST)
  end

  def test_never_connects
    run_server(Bane::Services::NeverListen.make(port, Bane::Services::LOCALHOST)) do
      assert_raise(Errno::ECONNREFUSED) {
        TCPSocket.new('localhost', port)
      }
    end
  end

  def port
    4001
  end

end
