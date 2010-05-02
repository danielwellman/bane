$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'bane'

include Bane
include Behaviors

launcher = Launcher.new(Configuration(
        10256 => CloseAfterPause,
        10689 => CloseAfterPause, # severs may be repeated
        11999 => CloseImmediately
      )
)
launcher.start
launcher.join
# runs until interrupt...