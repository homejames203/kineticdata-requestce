module Kinetic
  module TaskApiV2
    class SDK

      # Create a policy Rule
      #
      # Attributes
      #
      # +policy+ - hash of properties for the new policy rule
      # +headers+ - hash of headers to send, default is basic authentication and JSON content type
      #
      # Examples
      #
      # - create_policy_rule({
      #     "name" => "Foo",
      #     "type" => "Console Access | Category Access | API Access | System Default",
      #     "rule" => "...",
      #     "message" => "..."
      #   })
      #
      def create_policy_rule(policy, headers=default_headers)
        type = policy.delete("type")
        puts "Creating policy rule \"#{type} - #{policy['name']}\""
        post("/policyRules/#{url_encode(type)}", policy, headers)
      end

      # Delete a Policy Rule.
      #
      # Attributes
      #
      # +policy+ - a hash of policy type and name.
      # +headers+ - hash of headers to send, default is basic authentication
      #
      # Examples
      #
      # - delete_policy_rule({
      #     "type" => "API Access",
      #     "name" => "Company Network"
      #   })
      #
      def delete_policy_rule(policy, headers=header_basic_auth)
        puts "Deleting policy rule \"#{policy['type']} - #{policy['name']}\""
        delete("/policyRules/#{url_encode(policy['type'])}/#{url_encode(policy['name'])}", headers)
      end

      # Delete all Policy Rules.
      #
      # Attributes
      #
      # +headers+ - hash of headers to send, default is basic authentication
      def delete_policy_rules(headers=header_basic_auth)
        puts "Deleting all policy rules"
        find_policy_rules(headers).each do |policy_json|
          policy = JSON.parse(policy_json)
          delete_policy_rule({
            "type" => policy['type'],
            "name" => policy['name']
            }, headers)
        end
      end

      # Get a list of Policy Rules.
      #
      # Attributes
      #
      # +params+ - Query parameters to add to the URL, such as +include+
      # +headers+ - hash of headers to send, default is basic authentication
      def find_policy_rules(params={}, headers=header_basic_auth)
        puts "Retrieving Policy Rules"
        get("/policyRules", params, headers)
      end

      # Retrieve a single policy rule by type and name
      #
      # Attributes
      #
      # +type+ - the type of policy rule
      # +name+ - the name of the policy rule
      # +params+ - Query parameters to add to the URL, such as +include+
      # +headers+ - hash of headers to send, default is basic authentication
      def retrieve_policy_rule(type, name, params={}, headers=header_basic_auth)
        puts "Retrieving the \"#{type} - #{name}\" Policy Rule"
        get("/policyRules/#{url_encode(type)}/#{url_encode(name)}", params, headers)
      end

      # Retrieve a single policy rule
      #
      # Attributes
      #
      # +policy_rule+ - hash of properties that must contain 'type' and 'name'
      # +params+ - Query parameters to add to the URL, such as +include+
      # +headers+ - hash of headers to send, default is basic authentication
      #
      # Exammples
      #
      # - retrieve_policy_rule({ "type" => "API Access", "name" => "Allow All"})
      #
      def retrieve_policy_rule(policy_rule, params={}, headers=header_basic_auth)
        puts "Retrieving the \"#{policy_rule['type']} - #{policy_rule['name']}\" Policy Rule"
        get("/policyRules/#{url_encode(policy_rule['type'])}/#{url_encode(policy_rule['name'])}", params, headers)
      end

    end
  end
end
