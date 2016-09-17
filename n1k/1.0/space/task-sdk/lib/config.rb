module Kinetic
  module TaskApiV2
    class SDK

      # get the database configuration
      def retrieve_db
        puts "Retrieving database configuration"
        response = get("/config/db", {}, header_basic_auth)
        response.body
      end


      # Update the database configuration
      #
      # This assumes the database has already been created on the dbms
      #
      # Attributes
      #
      # +settings+ - the hash of settings for the selected type of dbms
      #
      def update_db(settings)
        puts "Updating the database properties"
        put("/config/db", settings, default_headers)
      end


      # Update the engine settings
      #
      # Attributes
      #
      # +settings+ - the hash of engine settings
      #
      def update_engine(settings)
        puts "Updating the engine properties"
        put("/config/engine", settings, default_headers)

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
      #
      def update_properties(settings)
        puts "Updating the web server properties"
        put("/config/server", body, default_headers)

        # reset the configuration user
        @config_user = {
          username: @custom['config_user']['username'],
          password: @custom['config_user']['password']
        }
      end

    end
  end
end
