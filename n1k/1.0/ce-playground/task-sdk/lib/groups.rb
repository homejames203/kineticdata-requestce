module Kinetic
  module TaskApiV2
    class SDK

      # Create a group
      def create_group(name, headers=default_headers)
        puts "Creating group \"#{name}\""
        post("/groups", { "name" => name }, headers)
      end

    end
  end
end
