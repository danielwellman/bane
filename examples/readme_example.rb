$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'bane'

include Bane
include Behaviors

launcher = Launcher.new(
        [Servers::ResponderServer.new(3000, Responders::FixedResponse.new(message: "Shall we play a game?"))])
launcher.start
launcher.join
