require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

class ServiceMakerTest < Test::Unit::TestCase
  include Bane

  def test_includes_behaviors_and_services_in_all_service_names
    maker = ServiceMaker.new
    all_names = maker.all_service_names

    assert all_names.include?('NeverRespond'), "Expected 'NeverRespond' behavior to be in #{all_names}"
    assert all_names.include?('NeverListen'), "Expected 'NeverRespond' service to be in #{all_names}"
  end
end