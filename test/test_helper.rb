require 'rubygems'
require 'test/unit'
require 'stringio'

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'bane'


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
