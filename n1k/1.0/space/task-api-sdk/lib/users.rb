module Kinetic
  module TaskApiV2
    class SDK

      # Create a user
      #
      # Attributes
      #
      # +user+ - hash of user properties
      # +headers+ - hash of headers to send, default is basic authentication and JSON content type
      #
      # Examples
      #
      # - create_user({
      #       "loginId" => "foo",
      #       "password" => "bar",
      #       "email" => "foo@bar.com"
      #     })
      #
      def create_user(user, headers=default_headers)
        puts "Creating user \"#{user['loginId']}\""
        post("/users", user, headers)
      end

      # Delete a User
      #
      # Attributes
      #
      # +login_id+ - login id of the user
      # +headers+ - hash of headers to send, default is basic authentication
      def delete_user(login_id, headers=header_basic_auth)
        puts "Deleting User \"#{login_id}\""
        delete("/users/#{url_encode(login_id)}", headers)
      end

      # Delete all Users
      #
      # Attributes
      #
      # +headers+ - hash of headers to send, default is basic authentication
      def delete_users(headers=header_basic_auth)
        puts "Deleting all users"
        find_users(headers).each do |user_json|
          user = JSON.parse(user_json)
          delete("/users/#{url_encode(user['login_id'])}", headers)
        end
      end

      # Retrieve all users
      #
      # Attributes
      #
      # +params+ - Query parameters to add to the URL, such as +include+
      # +headers+ - hash of headers to send, default is basic authentication
      def find_users(params={}, headers=header_basic_auth)
        puts "Retrieving all users"
        get("/users", params, headers)
      end

      # Update a user
      #
      # Attributes
      #
      # +login_id+ - Login Id for the user
      # +headers+ - hash of headers to send, default is basic authentication and JSON content type
      #
      # Examples
      #
      # - update_user({
      #       "loginId" => "foo",
      #       "password" => "bar",
      #       "email" => "foo@bar.com"
      #     })
      #
      def update_user(login_id, user, headers=default_headers)
        puts "Updating user \"#{login_id}\""
        put("/users/#{url_encode(login_id)}", user, headers)
      end

    end
  end
end
