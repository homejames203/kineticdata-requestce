# require colorize to highlight errors or warnings
require 'colorize'
# require all files in the lib directory
Dir[File.dirname(File.expand_path(__FILE__))+"/lib/**/*.rb"].each {|file| require file }

# Monkey patch IO.puts to create a log file for all puts statements
def puts str
  $stdout << "#{str}\n"
  if defined? @@logfile
    open(@@logfile, 'a') do |f|
      timestamp = Time.now.strftime('%Y-%m-%dT%H:%M:%S.%L')
      f.puts "#{timestamp} - #{str}"
    end
  end
end


module Kinetic
  module TaskApiV2
    class SDK

      attr_reader :api, :api_url, :server, :version,
                  :config_user, :defaults, :custom


      # Initalize the SDK with default and overridden custom values
      #
      # defaults = {
      #   "server" => "http://localhost:8080/kinetic-task",
      #   "config_user" => {
      #     "username" => "admin",
      #     "password" => "admin"
      #   }
      # }
      #
      # custom = {
      #   "config_user" => {
      #     "username" => "my-admin",
      #     "password" => "changed"
      #   },
      #   "db" => {
      #     "server" => {
      #       "host" => "localhost",
      #       "port" => "5432"
      #     },
      #     "user" => {
      #       "username" => "taskadmin",
      #       "password" => "TaskPass1"
      #     }
      #   },
      #   "engine" => {
      #     "delay" => "10",
      #     "threads" => "1",
      #     "trigger" => "'Selection Criterion'=null"
      #   },
      #   "source" => {
      #     "slug" => "space_slug",
      #     "server" => "http://localhost:8080/kinetic",
      #     "user" => {
      #       "username" => "task-integration-user",
      #       "password" => "task-integration-password"
      #     }
      #   }
      # }
      #
      def initialize(defaults, custom)
        init
        @defaults = defaults
        @custom = custom

        @server = defaults['server']
        @api_url = @server + @api
        @config_user = {
          username: defaults['config_user']['username'],
          password: defaults['config_user']['password']
        }
      end


      private

      def init
        @api = "/app/api/v2"
        @version = 2
      end

    end
  end
end
