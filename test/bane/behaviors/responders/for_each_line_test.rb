# frozen_string_literal: true

require_relative '../../../test_helper'
require 'mocha/test_unit'

class ForEachLineTest < Test::Unit::TestCase

  include Bane::Behaviors::Responders
  include BehaviorTestHelpers

  def test_reads_a_line_before_responding_with_parent_behavior
    server = SayHelloForEachLineBehavior.new

    fake_connection.will_send "irrelevant\n"

    query_server(server)
    assert_equal "Hello", response

    assert fake_connection.read_all_queries?
  end

  class SayHelloBehavior
    def serve(io)
      io.write('Hello')
    end
  end

  class SayHelloForEachLineBehavior < SayHelloBehavior
    include Bane::Behaviors::Responders::ForEachLine
  end
end
