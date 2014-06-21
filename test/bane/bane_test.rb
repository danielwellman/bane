require_relative '../test_helper'

class BaneTest < Test::Unit::TestCase

  def test_includes_responders_and_servers_in_all_makeables
    all_names = Bane.find_makeables.keys

    assert all_names.include?('NeverRespond'), "Expected 'NeverRespond' responder to be in #{all_names}"
    assert all_names.include?('TimeoutInListenQueue'), "Expected 'TimeoutInListenQueue' server to be in #{all_names}"
  end

end