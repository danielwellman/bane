require_relative '../test_helper'

class NaiveHttpResponseTest < Test::Unit::TestCase

  IRRELEVANT_RESPONSE_CODE = "999"
  IRRELEVANT_RESPONSE_DESCRIPTION = "Irrelevant description"
  IRRELEVANT_CONTENT_TYPE = "irrelevant content type"
  IRRELEVANT_BODY = "irrelevant body"

  def test_should_send_http_format_string
    response = response_for("200", "OK", IRRELEVANT_CONTENT_TYPE, IRRELEVANT_BODY)
    assert_equal "HTTP/1.1 200 OK\r\n", response.lines.first, "First line should be HTTP status"
  end

  def test_should_include_date
    assert_match /Date: .*/, any_response, 'Should have included a Date header'
  end

  def test_should_set_content_type
    response = response_for(IRRELEVANT_RESPONSE_CODE,
                            IRRELEVANT_RESPONSE_DESCRIPTION,
                            "text/xml",
                            IRRELEVANT_BODY)
    assert_match /Content-Type: text\/xml/, response, 'Should have included content type'
  end

  def test_should_set_content_length_as_length_of_body_in_bytes
    message = "Hello, there!"
    response = response_for(IRRELEVANT_RESPONSE_CODE,
                            IRRELEVANT_RESPONSE_DESCRIPTION,
                            IRRELEVANT_CONTENT_TYPE,
                            message)

    assert_match /Content-Length: #{message.length}/, response, 'Should have included content length'
  end

  def test_should_include_newline_between_headers_and_body
    message = "This is some body content."
    response = response_for(IRRELEVANT_RESPONSE_CODE,
                            IRRELEVANT_RESPONSE_DESCRIPTION,
                            IRRELEVANT_CONTENT_TYPE,
                            message)

    response_lines = response.lines.to_a
    index_of_body_start = response_lines.index(message)
    line_before_body = response_lines[index_of_body_start - 1]
    assert line_before_body.strip.empty?, "Should have had blank line before the body"
  end

  def test_should_include_the_body_at_the_end_of_the_response
    message = "This is some body content."
    response = response_for(IRRELEVANT_RESPONSE_CODE,
                            IRRELEVANT_RESPONSE_DESCRIPTION,
                            IRRELEVANT_CONTENT_TYPE,
                            message)
    assert_match /#{message}$/, response, "Should have ended the response with the body content"
  end

  private

  def response_for(response_code, response_description, content_type, body)
    NaiveHttpResponse.new(response_code, response_description, content_type, body).to_s
  end

  def any_response
    response_for(IRRELEVANT_RESPONSE_CODE, IRRELEVANT_RESPONSE_DESCRIPTION, IRRELEVANT_CONTENT_TYPE, IRRELEVANT_BODY)
  end

end