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

      # Update a user
      #
      # user = {
      #   "loginId" => "foo",
      #   "password" => "bar",
      #   "email" => "foo@bar.com"
      # }
      def update_user(login_id, user, headers=default_headers)
        puts "Updating user \"#{login_id}\""
        put("/users/#{url_encode(login_id)}", user, headers)
      end

    end
  end
end
