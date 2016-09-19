module Kinetic
  module TaskApiV2
    class SDK

      # Create a source
      #
      # Attributes
      #
      # +source+ - hash of properties for the source
      # +headers+ - hash of headers to send, default is basic authentication and JSON content type
      #
      # Examples
      #
      # - create_source(
      #     {
      #       "name" => "Source Name",
      #       "status" => "Active",
      #       "type" => "Kinetic Request CE",
      #       "properties" => {
      #         "Space Slug" => "foo",
      #         "Web Server" => "http://localhost:8080/kinetic",
      #         "Proxy Username" => "integration-user",
      #         "Proxy Password" => "integration-password"
      #       },
      #       "policyRules" => []
      #     }
      #
      def create_source(source, headers=default_headers)
        name = source['name']
        puts "Adding the #{name} source"
        post("/sources", source, headers)
      end

      # Delete a Source
      #
      # Attributes
      #
      # +name+ - name of the source
      # +headers+ - hash of headers to send, default is basic authentication
      def delete_source(name, headers=header_basic_auth)
        puts "Deleting Source \"#{name}\""
        delete("/sources/#{url_encode(name)}", headers)
      end

      # Delete all Sources
      #
      # Attributes
      #
      # +headers+ - hash of headers to send, default is basic authentication
      def delete_sources(headers=header_basic_auth)
        puts "Deleting all sources"
        find_sources(headers).each do |source_json|
          source = JSON.parse(source_json)
          delete("/sources/#{url_encode(source['name'])}", headers)
        end
      end

      # Retrieve all sources
      #
      # Attributes
      #
      # +params+ - Query parameters to add to the URL, such as +include+
      # +headers+ - hash of headers to send, default is basic authentication
      def find_sources(params={}, headers=header_basic_auth)
        puts "Retrieving all sources"
        get("/sources", params, headers)
      end

      # Retrieve a source
      #
      # Attributes
      #
      # +name+ - name of the source
      # +params+ - Query parameters to add to the URL, such as +include+
      # +headers+ - hash of headers to send, default is basic authentication and JSON content type
      def retrieve_source(name, params={}, headers=default_headers)
        puts "Retrieving source named \"#{name}\""
        get("/sources/#{url_encode(name)}", params, headers)
      end

      # Add policy rule to source
      #
      # Attributes
      #
      # +policy_rule_type+ - the type of policy rule
      # +policy_rule_name+ - the name of the policy rule
      # +source_name+ - name of the source to add the policy rule to
      # +headers+ - hash of headers to send, default is basic authentication and JSON content type
      def add_policy_rule_to_source(policy_rule_type, policy_rule_name, source_name, headers=default_headers)
        body = { "type" => policy_rule_type, "name" => policy_rule_name }
        puts "Adding policy rule \"#{policy_rule_type} - #{policy_rule_name}\" to source \"#{source_name}\""
        post("/sources/#{url_encode(source_name)}/policyRules", body, headers)
      end

      # Remove policy rule from source
      #
      # Attributes
      #
      # +policy_rule_type+ - the type of policy rule
      # +policy_rule_name+ - the name of the policy rule
      # +source_name+ - name of the source to remove the policy rule from
      # +headers+ - hash of headers to send, default is basic authentication and JSON content type
      def remove_policy_rule_from_source(policy_rule_type, policy_rule_name, source_name, headers=default_headers)
        puts "Removing policy rule \"#{policy_rule_type} - #{policy_rule_name}\" from source \"#{source_name}\""
        delete("/sources/#{url_encode(source_name)}/policyRules/#{url_encode(policy_rule_type)}/#{url_encode(policy_rule_name)}", headers)
      end

    end
  end
end
