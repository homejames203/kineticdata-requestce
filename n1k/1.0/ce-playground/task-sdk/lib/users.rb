module Kinetic
  module TaskApiV2
    class SDK

      # Create a user
      #
      # user = {
      #   "loginId" => "foo",
      #   "password" => "bar",
      #   "email" => "foo@bar.com"
      # }
      def create_user(user, headers=default_headers)
        puts "Creating user \"#{user['loginId']}\""
        post("/users", user, headers)
      end

    end
  end
end
