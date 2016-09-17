require 'rest-client'

module Kinetic
  module TaskApiV2
    class SDK

      # Make a HTTP DELETE request
      def delete(url, headers={})
        response = nil

        begin
          # send the request
          response = RestClient.delete(@api_url + url, headers)
        rescue StandardError => e
          puts "  ** #{e.inspect}".red
        end
        # return the response
        response
      end


      # Make a HTTP GET request
      def get(url, params={}, headers={})
        response = nil

        begin
          # send the request
          response = RestClient.get(@api_url + url, headers)
        rescue StandardError => e
          puts "  ** #{e.inspect}".red
        end
        # return the response
        response
      end

      # Make a HTTP POST request
      def post(url, body={}, headers={})
        response = nil
        # unless the body is already a string, assume JSON and convert to string
        body = body.to_json unless body.is_a? String

        begin
          # send the request
          response = RestClient.post(@api_url + url, body, headers)
        rescue StandardError => e
          puts "  ** #{e.inspect}".red
        end
        # return the response
        response
      end

      # Make a Multipart HTTP POST request
      def post_multipart(url, body={}, headers={})
        response = nil

        begin
          # send the request
          response = RestClient.post(@api_url + url, body, headers)
        rescue StandardError => e
          puts "  ** #{e.inspect}".red
        end
        # return the response
        response
      end

      # Make a HTTP PUT request
      def put(url, body={}, headers={})
        response = nil
        # unless the body is already a string, assume JSON and convert to string
        body = body.to_json unless body.is_a? String

        begin
          # send the request
          response = RestClient.put(@api_url + url, body, headers)
        rescue StandardError => e
          puts "  ** #{e.inspect}".red
        end
        # return the response
        response
      end

    end
  end
end
