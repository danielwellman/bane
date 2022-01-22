# frozen_string_literal: true

require_relative '../../../test_helper'

class HttpRefuseAllCredentialsTest < Test::Unit::TestCase

  include Bane::Behaviors::Responders
  include BehaviorTestHelpers

  def test_sends_401_response_code
    fake_connection.will_send("GET /some/irrelevant/path HTTP/1.1")

    server = HttpRefuseAllCredentials.new
    query_server(server)

    assert fake_connection.read_all_queries?, "Should have read the HTTP query before sending response"
    assert_match(/HTTP\/1.1 401 Unauthorized/, response, 'Should have responded with the 401 response code')
  end

end
