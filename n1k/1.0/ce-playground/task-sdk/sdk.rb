# require core libs and gems
require 'base64'
require 'colorize'
require 'rest-client'

# require all files in the lib directory
Dir[File.dirname(File.expand_path(__FILE__))+"/lib/*.rb"].each {|file| require file }

module Kinetic
  module TaskApiV2
    class SDK

      attr_reader :api, :api_url, :server, :version,
                  :config_user, :defaults, :custom

      def initialize(server, custom)
        init
        @defaults = {}
        @custom = custom

        @server = server
        @api_url = @server + @api
        @config_user = {
          username: @custom['config_user']['username'],
          password: @custom['config_user']['password']
        }
      end

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
