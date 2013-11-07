require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'
require 'socket'

class NeverListenTest < Test::Unit::TestCase

  include LaunchableRoleTests

  def setup
    @object = Bane::Services::NeverListen.make(IRRELEVANT_PORT, Bane::Services::DEFAULT_HOST)
  end

  def test_never_connects
    service = Bane::Services::NeverListen.make(port, Bane::Services::DEFAULT_HOST)
    service.stdlog = StringIO.new
    service.start

    assert_times_out {
      TCPSocket.new('localhost', port)
    }
  ensure
    service.stop
  end

  def port
    4001
  end

end
