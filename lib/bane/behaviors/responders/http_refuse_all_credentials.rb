module Bane
  module Behaviors
    module Responders

      # Sends an HTTP 401 response (Unauthorized) for every request.  This
      # attempts to mimic an HTTP server by reading a line (the request)
      # and then sending the response.  This behavior responds to all
      # incoming request URLs on the running port.
      class HttpRefuseAllCredentials
        UNAUTHORIZED_RESPONSE_BODY = <<EOF
<!DOCTYPE html>
<html>
  <head>
    <title>Bane Server</title>
  </head>
  <body>
    <h1>Unauthorized</h1>
  </body>
</html>
EOF

        def serve(io)
          io.gets # Read the request before responding
          response = NaiveHttpResponse.new(401, "Unauthorized", "text/html", UNAUTHORIZED_RESPONSE_BODY)
          io.write(response.to_s)
        end
      end

    end
  end
end