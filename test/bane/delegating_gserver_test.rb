require File.dirname(__FILE__) + '/../test_helper'
require 'mocha'

class DelegatingGserverTest < Test::Unit::TestCase
  include Bane
  
  IRRELEVANT_IO_STREAM = nil

  def test_serve_passes_a_hash_of_options_even_if_not_initialized_with_options
    behavior = mock()
    server = DelegatingGServer.new(IRRELEVANT_PORT, behavior)

    behavior.expects(:serve).with(anything(), is_a(Hash))

    server.serve(IRRELEVANT_IO_STREAM)
  end

  def test_serve_passes_constructor_options_to_behaviors_serve_method
    behavior = mock()
    
    initialized_options = {:expected => :options}
    server = DelegatingGServer.new(IRRELEVANT_PORT, behavior, initialized_options)

    behavior.expects(:serve).with(anything(), equals(initialized_options))

    server.serve(IRRELEVANT_IO_STREAM)
  end

end