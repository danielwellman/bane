require 'rubygems'
require 'test/unit'
require 'stringio'
require 'timeout'

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'bane'
require_relative 'bane/launchable_role_tests'

IRRELEVANT_PORT = 4001
IRRELEVANT_BEHAVIOR = 'CloseImmediately'

class FakeConnection < StringIO

  def will_send(query)
    commands.push query
  end

  def gets
    commands.pop
  end

  def read_all_queries?
    commands.empty?
  end

  private

  def commands
    @commands ||= []
  end
end

module BehaviorTestHelpers

  def fake_connection
    @fake_connection ||= FakeConnection.new
  end

  def query_server(server)
    server.serve(fake_connection)
  end

  def response
    fake_connection.string
  end

  def assert_empty_response
    assert_equal 0, response.length, "Should have sent nothing"
  end

  def assert_response_length(expected_length)
    assert_equal expected_length, response.length, "Response was the wrong length"
  end

end