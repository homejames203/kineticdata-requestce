module Kinetic
  module TaskApiV2
    class SDK

      # Create a group
      def create_group(name, headers=default_headers)
        puts "Creating group \"#{name}\""
        post("/groups", { "name" => name }, headers)
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
