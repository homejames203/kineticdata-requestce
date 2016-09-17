module Kinetic
  module TaskApiV2
    class SDK

      def create_category(name, headers=default_headers)
        body = { "name" => name }
        puts "Creating category \"#{name}\""
        post("/categories", body, headers)
      end

      # Delete a Category
      #
      # Attributes
      #
      # +name+ - name of the category
      # +headers+ - hash of headers to send, default is basic authentication
      def delete_category(name, headers=header_basic_auth)
        puts "Deleting Category \"#{name}\""
        delete("/categories/#{url_encode(name)}", headers)
      end

      # Delete all Categories
      #
      # Attributes
      #
      # +headers+ - hash of headers to send, default is basic authentication
      def delete_categories(headers=header_basic_auth)
        puts "Deleting all categories"
        find_categories(headers).each do |category_json|
          category = JSON.parse(category_json)
          delete("/categories/#{url_encode(category['name'])}", headers)
        end
      end

      # Retrieve all categories
      def find_categories(headers=header_basic_auth)
        puts "Retrieving all categories"
        get("/categories", headers)
      end

      # Retrieve a category
      def retrieve_category(category_name, headers=header_basic_auth)
        puts "Retrieving Category \"#{category_name}\""
        get("/categories/#{url_encode(category_name)}", headers)
      end


      def add_handler_to_category(handler_id, category_name, headers=default_headers)
        body = { "definitionId" => handler_id }
        puts "Adding handler \"#{handler_id}\" to category \"#{category_name}\""
        post("/categories/#{url_encode(category_name)}/handlers", body, headers)
      end

      def remove_handler_from_category(handler_id, category_name, headers=default_headers)
        puts "Removing handler \"#{handler_id}\" from category \"#{category_name}\""
        delete("/categories/#{url_encode(category_name)}/handlers/#{url_encode(handler_id)}", headers)
      end

      def add_routine_to_category(routine_id, category_name, headers=default_headers)
        body = { "definitionId" => routine_id }
        puts "Adding routine \"#{routine_id}\" to category \"#{category_name}\""
        post("/categories/#{url_encode(category_name)}/routines", body, headers)
      end

      def remove_routine_from_category(routine_id, category_name, headers=default_headers)
        puts "Removing routine \"#{routine_id}\" from category \"#{category_name}\""
        delete("/categories/#{url_encode(category_name)}/routines/#{url_encode(routine_id)}", headers)
      end

      def add_policy_rule_to_category(policy_rule_type, policy_rule_name, category_name, headers=default_headers)
        body = { "type" => policy_rule_type, "name" => policy_rule_name }
        puts "Adding policy rule \"#{policy_rule_type} - #{policy_rule_name}\" to category \"#{category_name}\""
        post("/categories/#{url_encode(category_name)}/policyRules", body, headers)
      end

      def remove_policy_rule_from_category(policy_rule_type, policy_rule_name, category_name, headers=default_headers)
        puts "Removing policy rule \"#{policy_rule_type} - #{policy_rule_name}\" from category \"#{category_name}\""
        delete("/categories/#{url_encode(category_name)}/policyRules/#{url_encode(policy_rule_type)}/#{url_encode(policy_rule_name)}", headers)
      end

    end
  end
end
