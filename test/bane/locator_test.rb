require File.dirname(__FILE__) + '/../test_helper'
require 'mocha'

class LocatorTest < Test::Unit::TestCase

  include Bane

  def setup
    @locator = Behaviors::Locator.new
  end

  def test_should_find_by_unqualified_string_name
    found = @locator.find("CloseImmediately")
    
    assert_equal Behaviors::CloseImmediately, found, "Should have found the CloseImmediately behavior"
  end

  def test_should_raise_exception_if_cannot_find_service_by_name
    assert_raises UnknownBehaviorError do
      @locator.find("SomeUnknownBehaviorName")
    end
  end

  def test_should_return_module_if_given
    found = @locator.find(Behaviors::CloseImmediately)
    
    assert_equal Behaviors::CloseImmediately, found, "Should have found the CloseImmediately behavior"
  end
end