require File.dirname(__FILE__) + '/../test_helper'
require 'net/telnet'

class BaneIntegrationTest < Test::Unit::TestCase

  TEST_PORT = 4000

  def setup()
    @launcher = Bane::Launcher.new(TEST_PORT, "NeverRespond")
    @launcher.start
  end

  def teardown()
    @launcher.stop
  end

  def test_uses_specified_port_and_server
    localhost = Net::Telnet::new("Host" => "localhost",
                                 "Port" => TEST_PORT,
                                 "Timeout" => 5)

    begin
      localhost.cmd("irrelevant command")
      fail "Should have never reponded"
    rescue Timeout::Error
      # expected exception
    ensure
      localhost.close
    end
  end
end