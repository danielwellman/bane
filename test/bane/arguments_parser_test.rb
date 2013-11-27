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

  def test_usage_message_includes_known_makeables
    usage = ArgumentsParser.new(['makeable1', 'makeable2']).usage
    assert_match /makeable1\W+makeable2/i, usage
  end

  def test_no_arguments_fail_with
    assert_invalid_arguments_fail_matching_message([], /missing arguments/i)
  end

  def test_non_integer_port_fails_with_error_message
    assert_invalid_arguments_fail_matching_message(['text_instead_of_an_integer'], /Invalid Port Number/i)
  end

  def test_invalid_option_fails_with_error_message
    assert_invalid_arguments_fail_matching_message(['--unknown-option', IRRELEVANT_PORT], /Invalid Option/i)
  end

  def parse(arguments)
    ArgumentsParser.new(["makeable1", "makeable2"]).parse(arguments)
  end

  def assert_parses_host(expected_host, arguments)
    config = parse(arguments)
    assert_equal expected_host, config.host
  end

  def assert_invalid_arguments_fail_matching_message(arguments, message_matcher)
    begin
      parse(arguments)
      flunk "Should have thrown an error"
    rescue ConfigurationError => ce
      assert_match message_matcher, ce.message
    end
  end

end