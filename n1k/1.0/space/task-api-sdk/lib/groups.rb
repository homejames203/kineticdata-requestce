module Kinetic
  module TaskApiV2
    class SDK

      # Create a group
      def create_group(name, headers=default_headers)
        puts "Creating group \"#{name}\""
        post("/groups", { "name" => name }, headers)
      end

      # Delete a Group
      #
      # Attributes
      #
      # +name+ - name of the group
      # +headers+ - hash of headers to send, default is basic authentication
      def delete_group(name, headers=header_basic_auth)
        puts "Deleting Group \"#{name}\""
        delete("/groups/#{url_encode(name)}", headers)
      end

      # Delete all Groups
      #
      # Attributes
      #
      # +headers+ - hash of headers to send, default is basic authentication
      def delete_groups(headers=header_basic_auth)
        puts "Deleting all groups"
        find_groups(headers).each do |group_json|
          group = JSON.parse(group_json)
          delete("/groups/#{url_encode(group['name'])}", headers)
        end
      end

      # Retrieve all groups
      def find_groups(headers=header_basic_auth)
        puts "Retrieving all groups"
        get("/groups", headers)
      end

      # Add user to group
      def add_user_to_group(login_id, group_name, headers=default_headers)
        body = { "loginId" => login_id }
        puts "Adding user \"#{login_id}\" to group \"#{group_name}\""
        post("/groups/#{url_encode(group_name)}/users", body, headers)
      end

      # Remove user from group
      def remove_user_from_group(login_id, group_name, headers=default_headers)
        puts "Removing user \"#{login_id}\" from group \"#{group_name}\""
        post("/groups/#{url_encode(group_name)}/users/#{url_encode(login_id)}", headers)
      end

    end
  end
end
