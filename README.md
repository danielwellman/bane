# Bane

Bane is a test harness used to test your application's interaction with other servers.  It is based upon the material from Michael Nygard's ["Release It!"](http://www.pragprog.com/titles/mnee/release-it) book as described in the "Test Harness" chapter.

## Usage

Bane is designed with a few usage scenarios in mind:

1. Quick start with a specific behavior from the command line.  If your application talks to another server on a given port, you can start Bane from the command line by specifying the desired port and a name of server behavior.  For example, if your server talks to a third-party server on port 8080, you could start the "Never Respond" behavior on port 8080 to observe how your application behaves.

   Example:  `$ bin/bane 8080 NeverRespond`

2. Quick start with multiple specific behaviors from the command line.  This will start each behavior on consecutive ports.

   Example:  `$ bin/bane 8080 NeverRespond CloseImmediately`

3. Quick start with all known behaviors from the command line.  This also starts each behavior on a consecutive port, starting from the supplied starting port.  If you just want a general purpose test harness to run, and you can easily control the ports that your application talks to, you can start Bane up with a base port number and it will start all its known behaviors.  This way you can leave Bane running and tweak your application to talk to each of the various behaviors.

   Example: `$ bin/bane 3000`

4. Advanced Configuration using Ruby.  If you want to modify some of the defaults used in the included behaviors, you can initialize Bane with a Hash of port numbers, behavior names, and configuration parameters.  For example, you might want to specify a response for the FixedResponse behavior:

   Example:

        require 'bane'

        include Bane
        include Behaviors

        launcher = Launcher.new(Configuration(
                3000 => {:behavior => FixedResponse, :message => "Shall we play a game?"},
              )
        )
        launcher.start
        launcher.join

   See `examples/specify_behavior_options.rb` for another example.  For a list of options supported by the
   basic behaviors, see the source for the behaviors in `Bane::Behaviors` at `lib/bane/behaviors.rb`.

## Background

See the "Test Harness" chapter from "Release It!" to read about the inspiration of Bane.

The following behaviors are currently supported in Bane, with the name of the behavior after the description in parenthesis.
Note that these are simple protocol-independent socket behaviors:

* The connection can be established, but the remote end never sends a byte of data (NeverRespond)
* The service can send one byte of the response every thirty seconds (SlowResponse)
* The server establishes a connection but sends a random reply (RandomResponse)
* The server accepts a connection and then drops it immediately (CloseImmediately)
* The service can send megabytes when kilobytes are expected. (rough approximation with the DelugeReponse)
* The service can refuse all authentication credentials. (HttpRefuseAllCredentials)

The following behaviors are not yet supported; they require the configuration of an HTTP server.
See the implementation of HttpRefuseAllCredentials for a simple example of an HTTP behavior.

* The service can accept a request, send response headers (supposing HTTP), and never send the response body.
* The service can send a response of HTML instead of the expected XML.

The following behaviors are not yet supported. These require the ability to manipulate
TCP packets at a low level; which may require a C or C++ extension.

* The connection can be refused.
* The request can sit in a listen queue until the caller times out.
* The remote end can reply with a SYN/ACK and then never send any data.
* The remote end can send nothing but RESET packets.
* The remote end can report a full receive window and never drain the data.
* The connection can be established, but packets could be lost causing retransmit delays
* The connection can be established, but the remote end never acknowledges receiving a packet, causing endless retransmits

## Design

Bane Behaviors are simple objects which implement the Strategy pattern.  This makes them
simple to unit test and allows them to be independent of the underlying server implementation.
Bane currently serves all Behaviors using Ruby's built-in GServer, which provides a simple
multi-threaded TCP server.  Behaviors currently:

* Accept an IO stream used to read from or send a response.
* Accept a hash of configuration options to allow overriding of default behavior parameters.
* Provide a meaningful name to appear in the Bane log.  This is especially helpful if your application
  under test dies and you'd like to identify which behavior killed it.

To enable support of different types of behaviors such as HTTP responses or low-level TCP packet
munging, a different base server instead of GServer may be required.  In that case, it should
be possible to change how Behaviors are associated with a server, perhaps by making
Behaviors extend a server base class.

