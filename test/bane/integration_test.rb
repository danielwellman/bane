require File.dirname(__FILE__) + '/../test_helper'
require 'net/telnet'

class BaneIntegrationTest < Test::Unit::TestCase

  TEST_PORT = 4000

  def test_uses_specified_port_and_server
    run_server_with(TEST_PORT, "NeverRespond") do
      telnet_to TEST_PORT do |conn|
        begin
          conn.cmd("irrelevant command")
          fail "Should have never reponded"
        rescue Timeout::Error
          # expected exception
        end
      end
    end
  end

  #TODO Finish this test
  def not_done__test_uses_behavior_options
    expected_message = "Expected test message"
    options = {TEST_PORT => {:behavior => Bane::Behaviors::FixedResponse,
                             :message => expected_message}}

    run_server_with(options) do
      telnet_to TEST_PORT do |conn|
        conn.cmd("irrelevant command") do |response|
          assert_equal expected_message, response, "Wrong response from server"
        end
      end
    end
  end

  private

  def run_server_with(* options)
    begin
      launcher = Bane::Launcher.new(Configuration(*options))
      launcher.start

      yield

    ensure
      launcher.stop
    end
  end

  def telnet_to(port)
    begin
      telnet = Net::Telnet::new("Host" => "localhost",
                                "Port" => TEST_PORT,
                                "Timeout" => 5)
      yield telnet
    ensure
      telnet.close
    end
  end
end
