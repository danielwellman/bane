require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'
require 'mocha/setup'

class BehaviorsTest < Test::Unit::TestCase

  include Bane::Behaviors
  include BehaviorTestHelpers

  def test_for_each_line_reads_a_line_before_responding
    server = Bane::Behaviors::FixedResponseForEachLine.new({message: "Dynamic"})

    fake_connection.will_send "irrelevant\n"

    query_server(server)
    assert_equal "Dynamic", response

    assert fake_connection.read_all_queries?
  end

end
