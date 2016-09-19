module Kinetic
  module TaskApiV2
    class SDK

      # Checks if the web application is alive
      #
      # Attributes
      #
      # +api_resource+ - the API resource route to get
      # +headers+ - hash of headers to send, default is basic authentication
      def is_alive?(api_resource, headers=header_basic_auth)
        alive = false
        begin
          response = get(api_resource, {}, headers)
          alive = !response.nil? && response.code == 200
        rescue Errno::ECONNREFUSED
          puts "#{$!.inspect}".red
        end
        alive
      end

      # Waits until the web server is alive
      #
      # Attributes
      #
      # +api_resource+ - the API resource route to get
      # +headers+ - hash of headers to send, default is basic authentication
      #
      def wait_until_alive(api_resource, headers=header_basic_auth)
        while !is_alive?(api_resource, headers) do
          puts "Web server is not ready, waiting..."
          sleep 3
        end
      end

    end
  end
end
