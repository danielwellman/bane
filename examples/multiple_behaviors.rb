$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'bane'

include Bane

# This example creates several behavior listening on distinct ports.
# Note the FixedResponse port specifies to listen to all hosts (0.0.0.0), all
# other servers listen to localhost only by default (127.0.0.1).

close_immediately = Behaviors::Responders::CloseImmediately.new
never_respond = Behaviors::Responders::NeverRespond.new
fixed_response = Behaviors::Responders::FixedResponse.new(message: "OK")

launcher = Launcher.new([ResponderServer.new(3000, close_immediately),
                        ResponderServer.new(8000, never_respond),
                        ResponderServer.new(8080, fixed_response, Behaviors::Services::ALL_INTERFACES)])
launcher.start
# To run until interrupt, use the following line:
#launcher.join

# For examples, we'll let these sleep for a few seconds and then shut down'
sleep 10
launcher.stop

