require 'base64'

module Kinetic
  module TaskApiV2
    class SDK

      # Provides a basic authentication header
      def header_basic_auth(username=@config_user[:username], password=@config_user[:password])
        { :Authorization => basic_auth(username, password) }
      end

      # Provides a content-type header set to application/json
      def header_content_json
        { :content_type => :json }
      end

      # Provides a hash of default headers
      #   Basic authentication
      #   Content-Type: application/json
      def default_headers(username=@config_user[:username], password=@config_user[:password])
        header_basic_auth(username, password).merge(header_content_json)
      end


      private

      # Provides the value for a basic authentication header
      def basic_auth(username=@config_user[:username], password=@config_user[:password])
        "Basic " + Base64.encode64(username + ":" + password)
      end

    end
  end
end
