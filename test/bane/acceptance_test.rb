require_relative '../test_helper'
require 'mocha/setup'

class BaneAcceptanceTest < Test::Unit::TestCase

  include ServerTestHelpers

  TEST_PORT = 4000

  def test_uses_specified_port_and_server
    run_server_with(TEST_PORT, Bane::Behaviors::Responders::FixedResponse) do
      with_response_from TEST_PORT do |response|
        assert !response.empty?, "Should have had a non-empty response"
      end
    end
  end

  def test_serves_http_requests
    run_server_with(TEST_PORT, Bane::Behaviors::Responders::HttpRefuseAllCredentials) do
      assert_match /401/, status_returned_from("http://localhost:#{TEST_PORT}/some/url")
    end
  end

  def test_supports_command_line_interface
    run_server_with_cli_arguments(["--listen-on-localhost", TEST_PORT, "FixedResponse"]) do
      with_response_from TEST_PORT do |response|
        assert !response.empty?, "Should have had a non-empty response"
      end
    end
  end

  private

  def run_server_with(port, behavior, &block)
    behavior = Bane::Behaviors::Services::ResponderServer.new(port, behavior.new)
    launcher = Bane::Launcher.new([behavior], quiet_logger)
    launch_and_stop_safely(launcher, &block)
    sleep 0.1 # Until we can fix the GServer stopping race condition (Issue #7)
  end

  def run_server_with_cli_arguments(arguments, &block)
    config = Bane::CommandLineConfiguration.new(Bane.find_makeables)
    launcher = Bane::Launcher.new(config.process(arguments), quiet_logger) { |error| raise error }
    launch_and_stop_safely(launcher, &block)
    sleep 0.1 # Until we can fix the GServer stopping race condition (Issue #7)
  end

  def quiet_logger
    StringIO.new
  end

  def status_returned_from(uri)
    Net::HTTP.get_response(URI(uri)).code
  end

  def with_response_from(port)
    begin
      connection = TCPSocket.new "localhost", port
      yield connection.read
    ensure
      connection.close if connection
    end
  end

end
