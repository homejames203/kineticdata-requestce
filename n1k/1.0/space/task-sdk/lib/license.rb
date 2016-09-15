module Kinetic
  module TaskApiV2
    class SDK

      # Update the license if it was provided
      def update_license(license_filename)
        puts "Checking if need to update the license"
        if File.exists? license_filename
          license = File.read(license_filename)
          if license.size == 0
            puts "  * License is empty, skip applying license".yellow
          else
            body = { "licenseContent" => license }
            puts "Updating license"
            response = post("/config/license", body, default_headers)
          end
        else
          puts "  * No license file found, skip applying license".yellow
        end
      end

    end
  end
end
