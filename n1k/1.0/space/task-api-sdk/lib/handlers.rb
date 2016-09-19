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
      #
      # Attributes
      #
      # +params+ - Query parameters to add to the URL, such as +include+
      # +headers+ - hash of headers to send, default is basic authentication
      def find_sources(params={}, headers=header_basic_auth)
        puts "Retrieving all sources"
        get("/sources", params, headers)
      end

      # Retrieve a handler
      #
      # Attributes
      #
      # +definition_id+ - the definition_id of the handler
      # +params+ - Query parameters to add to the URL, such as +include+
      # +headers+ - hash of headers to send, default is basic authentication
      def retrieve_handler(definition_id, params={}, headers=header_basic_auth)
        puts "Retrieving handler \"#{definition_id}\""
        get("/handlers/#{definition_id}", params, headers)
      end

      # Import a handler file
      #
      # If the handler already exists on the server,
      # this will fail unless forced to overwrite.
      #
      # Attributes
      #
      # +handler+ - handler zip package file
      # +force_overwrite+ - whether to overwrite a handler if it exists, default is false
      # +headers+ - hash of headers to send, default is basic authentication
      def import_handler(handler, force_overwrite=false, headers=header_basic_auth)
        body = { "package" => handler }
        puts "Importing Handler #{File.basename(handler)}"
        post_multipart("/handlers?force=#{force_overwrite}", body, headers)
      end

      # Modifies the properties and info values for a handler
      #
      # Attributes
      #
      # +definition_id+ - the definition_id of the handler
      # +body+ - hash of properties to update
      # +headers+ - hash of headers to send, default is basic authentication and JSON content type
      def update_handler(definition_id, body, headers=default_headers)
        puts "Updating handler #{definition_id}"
        put("/handlers/#{definition_id}", body, headers)
      end

    end
  end
end
