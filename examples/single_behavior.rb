$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'bane'

include Bane
include Behaviors

# This example creates a single behavior listening on port 3000.
# Note that the behavior, CloseAfterPause, specifies a default duration to pause - 60 seconds.

behavior = Servers::ResponderServer.new(3000, Responders::CloseAfterPause.new(duration: 60))
launcher = Launcher.new([behavior])
launcher.start
# To run until interrupt, use the following line:
#launcher.join

# For examples, we'll let these sleep for a few seconds and then shut down'
sleep 10
launcher.stop

