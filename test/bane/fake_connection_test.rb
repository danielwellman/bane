require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

class FakeConnectionTest < Test::Unit::TestCase

  def setup
    @fake_connection = FakeConnection.new
  end

  def test_fake_connection_returns_nil_if_no_commands_to_read
    assert_nil @fake_connection.gets
  end

  def test_fake_connection_reports_when_one_command_set_and_read
    @fake_connection.will_send("Command #1")

    @fake_connection.gets

    assert @fake_connection.read_all_queries?, "Should have read all queries"
  end

  def test_fake_connection_reports_when_all_commands_read
    @fake_connection.will_send("Command #1")
    @fake_connection.will_send("Command #2")

    @fake_connection.gets

    assert !@fake_connection.read_all_queries?, "Did not read all queries yet"

    @fake_connection.gets

    assert @fake_connection.read_all_queries?, "Should have read all queries"
  end

end