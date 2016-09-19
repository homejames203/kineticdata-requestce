module Kinetic
  module TaskApiV2
    class SDK

      # Retrieve the database configuration
      #
      # Attributes
      #
      # +params+ - Query parameters to add to the URL, such as +include+
      # +headers+ - hash of headers to send, default is basic authentication
      def retrieve_db(params={}, headers=header_basic_auth)
        puts "Retrieving database configuration"
        response = get("/config/db", params, headers)
        response.body
      end


      # Update the database configuration
      #
      # This assumes the database has already been created on the dbms
      #
      # Attributes
      #
      # +settings+ - the hash of settings for the selected type of dbms
      # +headers+ - hash of headers to send, default is basic authentication and JSON content type
      def update_db(settings, headers=default_headers)
        puts "Updating the database properties"
        put("/config/db", settings, headers)
      end


      # Update the engine settings
      #
      # Attributes
      #
      # +settings+ - the hash of engine settings
      # +headers+ - hash of headers to send, default is basic authentication and JSON content type
      def update_engine(settings, headers=default_headers)
        puts "Updating the engine properties"
        put("/config/engine", settings, headers)

        # start the task engine?
        if @custom['engine']['delay'].to_i > 0
          puts "Starting the engine"
          start_engine
        end
      end


      # Update the web server and default configuration user settings
      #
      # Attributes
      #
      # +settings+ - the hash of settings for the web server and configuration user
      # +headers+ - hash of headers to send, default is basic authentication and JSON content type
      def update_properties(settings, headers=default_headers)
        puts "Updating the web server properties"
        put("/config/server", settings, headers)

        # reset the configuration user
        @config_user = {
          username: @custom['config_user']['username'],
          password: @custom['config_user']['password']
        }
      end

    end
  end
end
