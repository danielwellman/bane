require 'rubygems'
require 'bane'

# Start up a default configuration of
# many useful port responders so we can
# just start testing.  On startup, the port 
# configuration will be printed to STDOUT.
Launcher.new(3000).run

# Start up using the specified port and automatically
# assign the given responders in increasing order
Launcher.new(3000, RefuseConnection, ConnectSlowly, NeverReply, RandomReply, DropImmediately)

# Start up using the provided map of port to responder types
Launcher.new(
   3000 => RefuseConnection,
   3001 => SitInListenQueueForever,
   3002 => ReplyWithSynAckThenNoData,
   3003 => AlwaysSendReset,
   3004 => ReportFullReceiveWindowThenNeverDrainData,
   3005 => ConnectButNeverReply,
   3006 => ConnectButLosePacketsAndIncurRetransmitDelays,
   3007 => ConnectButNeverAcknowledgePacketReceive,
   3008 => SendOneByteEveryThirySeconds,
   3009 => DelugeResponse,
   3010 => ConnectButRespondRandomly,
   3011 => ConnectThenDrop,
).run


