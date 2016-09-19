module Kinetic
  module TaskApiV2
    class SDK

      # Start the task engine
      #
      # Attributes
      #
      # +headers+ - hash of headers to send, default is basic authentication and JSON content type
      def start_engine(headers=default_headers)
        body = { "action" => "start" }
        post("/engine", body, headers)
      end

      # Stop the task engine
      #
      # Attributes
      #
      # +headers+ - hash of headers to send, default is basic authentication and JSON content type
      def stop_engine(headers=default_headers)
        body = { "action" => "stop" }
        post("/engine", body, headers)
      end

      # Get the engine info
      #
      # Attributes
      #
      # +params+ - Query parameters to add to the URL, such as +include+
      # +headers+ - hash of headers to send, default is basic authentication
      def engine_info(params={}, headers=header_basic_auth)
        get("/engine", params, headers)
      end

      # Get the engine status
      #
      # Attributes
      #
      # +headers+ - hash of headers to send, default is basic authentication
      def engine_status(headers=header_basic_auth)
        response = engine_info({}, headers)
        data = JSON.parse response.body
        data.nil? ? "Unknown" : data['status']
      end

    end
  end
end
