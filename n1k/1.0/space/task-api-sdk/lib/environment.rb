module Kinetic
  module TaskApiV2
    class SDK

      # Get the web server environment
      #
      # Attributes
      #
      def environment(headers=header_basic_auth)
        get("/environment", {}, headers)
      end

    end
  end
end
