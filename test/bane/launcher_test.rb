require File.dirname(__FILE__) + '/../test_helper'
require 'mocha'

module Bane
  module Behaviors
    class FakeTestServer < BasicBehavior
    end
  end
end

class LauncherTest < Test::Unit::TestCase

  def test_starts_single_server_on_specified_port
    target_port = 4000
    Bane::DelegatingGServer.expects(:new).with(equals(target_port), anything()).returns(stub_everything('fake_server'))

    launcher = Bane::Launcher.new(FakeConfiguration.new(target_port, Bane::Behaviors::FakeTestServer))
    launcher.start
  end

  class FakeConfiguration
    include Enumerable

    def initialize(port, behavior)
      @entries = []
      @entries << Bane::Configuration::ConfigurationRecord.new(port, behavior)
    end

    def each
      @entries.each do |entry|
        yield entry.port, entry.server
      end
    end
  end
end