module Kinetic
  module TaskApiV2
    class SDK

      # Get the web server environment
      #
      # Attributes
      #
      # +params+ - Query parameters to add to the URL, such as +include+
      # +headers+ - hash of headers to send, default is basic authentication
      def environment(params={}, headers=header_basic_auth)
        get("/environment", params, headers)
      end

    end
  end
end
