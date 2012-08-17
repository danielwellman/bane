$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'bane'

include Bane

launcher = Launcher.new(
        [BehaviorServer.new(3000, Behaviors::FixedResponse.new(:message => "Shall we play a game?"))])
launcher.start
launcher.join
