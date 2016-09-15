module Kinetic
  module TaskApiV2
    class SDK

      # Start the task engine
      def start_engine(headers=default_headers)
        body = { "action" => "start" }
        post("/engine", body, headers)
      end

      # Stop the task engine
      def stop_engine(headers=default_headers)
        body = { "action" => "stop" }
        post("/engine", body, headers)
      end

      # Get the engine info
      def engine_info(headers=header_basic_auth)
        get("/engine", {}, headers)
      end

      # Get the engine status
      def engine_status(headers=header_basic_auth)
        response = get("/engine", {}, headers)
        data = JSON.parse response.body
        data.nil? ? "Unknown" : data['status']
      end

    end
  end
end
