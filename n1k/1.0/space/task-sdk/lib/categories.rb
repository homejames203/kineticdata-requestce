module Kinetic
  module TaskApiV2
    class SDK

      def create_category(name, headers=default_headers)
        body = { "name" => name }
        puts "Creating category \"#{name}\""
        post("/categories", body, headers)
      end

    end
  end
end
