module Kinetic
  module TaskApiV2
    class SDK

      # Delete the license
      #
      # Attrubutes
      #
      # +headers+ - hash of headers to send, default is basic authentication
      def delete_license(headers=header_basic_auth)
        puts "Deleting the license"
        delete("/config/license", {}, headers)
      end

      # Retrieve the license
      #
      # Attrubutes
      #
      # +params+ - Query parameters to add to the URL, such as +include+
      # +headers+ - hash of headers to send, default is basic authentication
      def retrieve_license(params={}, headers=header_basic_auth)
        puts "Retrieving the license"
        get("/config/license", params, headers)
      end

      # Update the license
      #
      # Attributes
      #
      # +license_content+ - the content of the license file
      # +headers+ - hash of headers to send, default is basic authentication and JSON content type
      def update_license(license_content, headers=default_headers)
        body = { "licenseContent" => license_content }
        puts "Updating license"
        post("/config/license", body, headers)
      end

      # Imports the license file
      #
      # Attributes
      #
      # +license+ - either the license file path (String), or the license file (File)
      # +headers+ - hash of headers to send, default is basic authentication and JSON content type
      def import_license(license, headers=default_headers)
        if license.is_a? File
          update_license(license.read, headers)
        else
          if File.exists? license
            update_license(File.read(license), headers)
          else
            puts "  * License file \"#{license}\" does not exist.".yellow
          end
        end
      end

    end
  end
end
