$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'bane'

include Bane

launcher = Launcher.new(3000, Behaviors::CloseImmediately, Behaviors::CloseAfterPause)
launcher.start
launcher.join
# runs until interrupt...