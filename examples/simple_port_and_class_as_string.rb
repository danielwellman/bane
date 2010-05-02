$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'bane'

launcher = Bane::Launcher.new(Configuration(3000, "CloseImmediately"))
launcher.start
launcher.join
# runs until interrupt...