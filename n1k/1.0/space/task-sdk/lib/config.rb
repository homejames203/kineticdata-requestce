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
      # This assumes the database has already been created on the dbms
      def update_db
        body = {
          "hibernate.connection.driver_class" => "org.postgresql.Driver",
          "hibernate.connection.url" => "jdbc:postgresql://#{@custom['db']['server']['host']}:#{@custom['db']['server']['port']}/#{@custom['db']['name']}",
          "hibernate.connection.username" => @custom['db']['user']['username'],
          "hibernate.connection.password" => @custom['db']['user']['password'],
          "hibernate.dialect" => "com.kineticdata.task.adapters.dbms.KineticPostgreSQLDialect"
        }
        puts "Updating the database properties"
        put("/config/db", body, default_headers)
      end


      # Update the engine settings
      def update_engine
        body = {
          "Max Threads" => @custom['engine']['threads'],
          "Sleep Delay" => @custom['engine']['delay'],
          "Trigger Query" => @custom['engine']['trigger']
        }
        puts "Updating the engine properties"
        put("/config/engine", body, default_headers)

        # start the task engine?
        if @custom['engine']['delay'].to_i > 0
          puts "Starting the engine"
          start_engine
        end
      end


      # Update the web server and default configuration user settings
      def update_properties
        body = {
          "Configurator Username" => @custom['config_user']['username'],
          "Configurator Password" => @custom['config_user']['password']
        }
        body["Log Level"] = @custom['source']['log_level'] unless @custom['source']['log_level'].nil?
        body["Log Size (MB)"] = @custom['source']['log_size'] unless @custom['source']['log_size'].nil?

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
