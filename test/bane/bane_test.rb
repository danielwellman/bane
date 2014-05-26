require_relative '../test_helper'

class BaneTest < Test::Unit::TestCase

  def test_includes_behaviors_and_services_in_all_makeables
    all_names = Bane.find_makeables.keys

    assert all_names.include?('NeverRespond'), "Expected 'NeverRespond' behavior to be in #{all_names}"
    assert all_names.include?('TimeoutInListenQueue'), "Expected 'TimeoutInListenQueue' service to be in #{all_names}"
  end

end