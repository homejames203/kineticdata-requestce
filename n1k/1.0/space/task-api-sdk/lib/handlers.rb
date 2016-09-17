module Kinetic
  module TaskApiV2
    class SDK

      # Delete a Handler
      #
      # Attributes
      #
      # +definition_id+ - the handler definiton id
      # +headers+ - hash of headers to send, default is basic authentication
      def delete_handler(definition_id, headers=header_basic_auth)
        puts "Deleting Handler \"#{definition_id}\""
        delete("/handlers/#{definition_id}", headers)
      end

      # Delete all Handlers
      #
      # Attributes
      #
      # +headers+ - hash of headers to send, default is basic authentication
      def delete_handlers(headers=header_basic_auth)
        puts "Deleting all handlers"
        find_handlers(headers).each do |handler_json|
          handler = JSON.parse(handler_json)
          delete("/handlers/#{handler['definition_id']}", headers)
        end
      end

      # Retrieve all sources
      def find_sources(headers=header_basic_auth)
        puts "Retrieving all sources"
        get("/sources", headers)
      end

      # Retrieve a handler
      def retrieve_handler(definition_id, headers=header_basic_auth)
        puts "Retrieving handler \"#{definition_id}\""
        get("/handlers/#{definition_id}", headers)
      end

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
