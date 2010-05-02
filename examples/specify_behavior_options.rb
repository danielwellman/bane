$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'bane'

include Bane
include Behaviors

launcher = Launcher.new(Configuration(
        10256 => {:behavior => CloseAfterPause, :duration => 3},
        10689 => {:behavior => SlowResponse, :message => "Custom message", :pause_duration => 15},
        11239 => CloseAfterPause # Use the defaults for this behavior, don't need a Hash
      )
)
launcher.start
launcher.join
# runs until interrupt...