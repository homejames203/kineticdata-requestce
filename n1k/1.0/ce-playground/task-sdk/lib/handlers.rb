module Kinetic
  module TaskApiV2
    class SDK

      # Import a handler file
      #
      # If the handler already exists on the server,
      # this will fail unless forced to overwrite
      def import_handler(handler, force_overwrite=false, headers=header_basic_auth)
        body = { "package" => handler }
        puts "Importing Handler #{File.basename(handler)}"
        post_multipart("/handlers?force=#{force_overwrite}", body, headers)
      end

      # Modifies the properties and info values for a handler
      def update_handler(handler_id, body, headers=default_headers)
        puts "Updating handler #{handler_id}"
        put("/handlers/#{handler_id}", body, headers)
      end

    end
  end
end
