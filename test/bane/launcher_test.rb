require File.dirname(__FILE__) + '/../test_helper'
require 'mocha'

class LauncherTest < Test::Unit::TestCase

  include Bane

  def test_start_delegates_to_configuration
    configuration = mock()
    launcher = Launcher.new(configuration)

    configuration.expects(:start)
    launcher.start
  end
end