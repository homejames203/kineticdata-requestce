module Kinetic
  module TaskApiV2
    class SDK

      # checks if the web application is alive
      def is_alive?(headers=header_basic_auth)
        alive = false
        begin
          response = get("/environment", {}, headers)
          alive = !response.nil? && response.code == 200
        rescue Errno::ECONNREFUSED
          puts "#{$!.inspect}".red
        end
        alive
      end

      # waits until the web server is alive
      def wait_until_alive(headers=header_basic_auth)
        while !is_alive?(headers) do
          puts "Web server is not ready, waiting..."
          sleep 3
        end
      end

    end
  end
end
