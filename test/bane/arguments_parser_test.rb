require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

class ArgumentsParserTest < Test::Unit::TestCase
  include Bane

  # Parsing arguments (uses the isolated ArgumentsParser object)

  def test_parses_the_port
    config = parse(["3000", IRRELEVANT_BEHAVIOR])
    assert_equal 3000, config.port
  end

  def test_parses_the_services
    config = parse([IRRELEVANT_PORT, 'NeverRespond', 'EchoResponse'])
    assert_equal ['NeverRespond', 'EchoResponse'], config.services
  end

  def test_host_defaults_to_localhost_if_not_specified
    config = parse([IRRELEVANT_PORT, IRRELEVANT_BEHAVIOR])
    assert_equal '127.0.0.1', config.host
  end

  def test_dash_l_option_sets_listen_host_to_localhost
    assert_parses_host(Services::DEFAULT_HOST, ['-l', IRRELEVANT_PORT, IRRELEVANT_BEHAVIOR])
  end

  def test_listen_on_localhost_sets_listen_host_to_localhost
    assert_parses_host(Services::DEFAULT_HOST, ['--listen-on-localhost', IRRELEVANT_PORT, IRRELEVANT_BEHAVIOR])
  end

  def test_dash_a_option_sets_listen_host_to_all_interfaces
    assert_parses_host(Services::ALL_INTERFACES, ['-a', IRRELEVANT_PORT, IRRELEVANT_BEHAVIOR])
  end

  def test_listen_on_all_hosts_option_sets_listen_host_to_all_interfaces
    assert_parses_host(Services::ALL_INTERFACES, ['--listen-on-all-hosts', IRRELEVANT_PORT, IRRELEVANT_BEHAVIOR])
  end


  def parse(arguments)
    ArgumentsParser.new.parse(arguments)
  end

  def assert_parses_host(expected_host, arguments)
    config = parse(arguments)
    assert_equal expected_host, config.host
  end

end