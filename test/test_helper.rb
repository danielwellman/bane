require 'rubygems'
require 'test/unit'
require 'stringio'
require 'timeout'

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'bane'
require_relative 'bane/launchable_role_tests'

def assert_times_out
  assert_raise Timeout::Error do
    Timeout::timeout(1) { yield }
  end
end


IRRELEVANT_PORT = 4001

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
