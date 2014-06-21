# master

### Added
 * Trap SIGINT to gracefully stop servers
 * Remove Ruby 1.8.7 support
 * The EchoResponse behavior which replies with each line sent
 * The NeverListen server which binds to a port but never calls listen(2)

### Removed
 * The fancy, flexible ConfigurationParser has been deleted. Command-line invocation now uses the CommandLineConfiguration parser.  For programmatic invocation, see the examples.

### Changed
  * Rearranged packages to create Bane::Behaviors::Servers and Bane::Beaviors::Responders.  Servers may be started and stopped; Responders simply interact with an already connected socket.
  * Added Bane::Behaviors::Servers::LOCALHOST (127.0.0.1) and deprecated Bane::Behaviors::Servers::DEFAULT_HOST; please use LOCALHOST when specifying a host to listen on.

# 0.3.0

### Added
 * Servers can now listen on all hosts or localhost via the command-line options -a / --listen-on-all-hosts or -l / --listen-on-localhost.  The default is to listen on localhost.


### Changed
 * Behaviors receive their parameters through their constructors instead of being passed via the serve method.  That is,
  the serve(io, options) method has been changed to serve(io).  Behaviors that need to accept user-specified parameters
  should accept them via constructor arguments, and should provide a default version since the command-line interface
  does not specify options.  e.g.

```
class MyBehavior
   def initialize(options = {})
   ...
```

* BehaviorServer no longer accepts options; instead these are created with the Behavior objects.
* Configuration() and ConfigurationParser class are deprecated and will be removed in the next release.  Instead of 
  using these classes, please directly instantiate a BehaviorServer with the required arguments.  This class is being
  deprecated and removed because the flexibility of the code creates a structure that is harder to read and maintain.
  I'm also not sure anyone is using this method -- if so, please open a GitHub Issue and let me know if you're using 
  it -- and if so, how.



