# frozen_string_literal: true

class NaiveHttpResponse

  CRLF        = "\r\n"

  class HttpHeader
    def initialize(headers)
      @headers = headers
    end

    def to_s
      @headers.map { |k, v| "#{k}: #{v}" }.join(CRLF)
    end

  end

  def initialize(response_code, response_description, content_type, body)
    @code = response_code
    @description = response_description
    @content_type = content_type
    @body = body
  end

  def to_s
    str = []
    str << "HTTP/1.1 #{@code} #{@description}"
    str << http_header.to_s
    str << ""
    str << @body
    str.join(CRLF)
  end

  private

  def http_header()
    HttpHeader.new(
            {"Server" => "Bane HTTP Server",
             "Connection" => "close",
             "Date" => http_date(Time.now),
             "Content-Type" => @content_type,
             "Content-Length" => @body.length})
  end

  def http_date(time)
    time.gmtime.strftime("%a, %d %b %Y %H:%M:%S GMT")
  end
end
