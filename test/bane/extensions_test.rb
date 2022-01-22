# frozen_string_literal: true

require_relative '../test_helper'

class ExtensionsTest < Test::Unit::TestCase
  def test_unqualified_name_removes_module_path
    assert_equal 'String', String.unqualified_name
    assert_equal 'NestedClass', TopModule::NestedClass.unqualified_name
    assert_equal 'DoublyNestedClass', TopModule::NestedModule::DoublyNestedClass.unqualified_name
  end
end

module TopModule
  class NestedClass; end

  module NestedModule
    class DoublyNestedClass; end
  end
end