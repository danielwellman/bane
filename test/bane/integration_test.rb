require File.dirname(__FILE__) + '/../test_helper'
require 'net/telnet'

class BaneIntegrationTest < Test::Unit::TestCase

  TEST_PORT = 4000

  def test_uses_specified_port_and_server
    run_server_with(TEST_PORT, "FixedResponse") do
      telnet_to TEST_PORT do |response|
        assert !response.empty?, "Should have had a non-empty response"
      end
    end
  end

  def test_uses_behavior_options
    expected_message = "Expected test message"
    options = {TEST_PORT => {:behavior => Bane::Behaviors::FixedResponse,
                             :message => expected_message}}

    run_server_with(options) do
      telnet_to TEST_PORT do |response|
        assert_equal expected_message, response, "Wrong response from server"
      end
    end
  end

  private

  def run_server_with(*options)
    begin
      launcher = Bane::Launcher.new(Configuration(*options), quiet_logger)
      launcher.start
      yield
    ensure
      launcher.stop
    end
  end

  def quiet_logger
    StringIO.new
  end
  
  def telnet_to(port)
    begin
      telnet = Net::Telnet::new("Host" => "localhost",
                                "Port" => port,
                                "Timeout" => 5)
      yield telnet.read
    ensure
      telnet.close
    end
  end
end
