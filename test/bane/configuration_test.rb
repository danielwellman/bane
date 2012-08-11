require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'
require 'mocha'

class ConfigurationTest < Test::Unit::TestCase
  include Bane

  def test_creates_specified_behavior_on_given_port
    expect_server_created_with(:port => 3000, :behavior => Behaviors::CloseImmediately)

    create_configuration_for([3000, "CloseImmediately"])
  end

  def test_creates_all_known_behavior_if_only_port_specified
    first_behavior = unique_behavior
    second_behavior = unique_behavior

    expect_server_created_with :port => 4000, :behavior => first_behavior
    expect_server_created_with :port => 4001, :behavior => second_behavior

    ServiceRegistry.expects(:all_servers).returns([first_behavior, second_behavior])

    create_configuration_for([4000])
  end

  def test_creates_multiple_behaviors_starting_on_given_port
    expect_server_created_with :port => 3000, :behavior => Behaviors::CloseImmediately
    expect_server_created_with :port => 3001, :behavior => Behaviors::CloseAfterPause

    create_configuration_for([3000, "CloseImmediately", "CloseAfterPause"])
  end


  private

  def create_configuration_for(array)
    config = Configuration.from(array)
    config.servers
  end


  def unique_behavior
    Class.new
  end

  def expect_server_created_with(arguments)
    arguments = { :options => anything() }.merge(arguments)
    BehaviorServer.expects(:new).with(arguments[:port], instance_of(arguments[:behavior]), arguments[:options])
  end

end