require File.dirname(__FILE__) + '/../test_helper'
require 'mocha'

class LauncherTest < Test::Unit::TestCase

  include Bane

  def test_start_delegates_to_configuration
    configuration = mock()
    logger = stub()
    launcher = Launcher.new(configuration, logger)

    configuration.expects(:start).with(equals(logger))
    launcher.start
  end
end