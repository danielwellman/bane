require 'test_helper'
require 'net/telnet'

class BaneIntegrationTest < Test::Unit::TestCase

  def test_uses_specified_port_and_server
    launcher = Bane::Launcher.new(4000, "CloseImmediately")
    thread = Thread.new(launcher) do |launcher_thread|
      launcher_thread.start
    end

    localhost = Net::Telnet::new("Host" => "localhost",
                                 "Port" => 4000,
                                 "Timeout" => 10,
                                 "Prompt" => /[$%#>] \z/n)
    begin
      localhost.cmd("ignored") { |c| print c }
      fail "Should have closed immediately without accepting command"
    rescue Errno::ECONNRESET
      # expected
    ensure
      localhost.close
    end

    launcher.stop
  end
end