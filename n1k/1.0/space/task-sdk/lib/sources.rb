module Kinetic
  module TaskApiV2
    class SDK

      # Create a source
      #
      # {
      #   "name" => "Source Name",
      #   "status" => "Active",
      #   "type" => "Kinetic Request CE",
      #   "properties" => {
      #     "Space Slug" => "foo",
      #     "Web Server" => "http://localhost:8080/kinetic",
      #     "Proxy Username" => "integration-user",
      #     "Proxy Password" => "integration-password"
      #   },
      #   "policyRules" => []
      # }
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
          delete("/sources/#{url_encode(source['name')}", headers)
        end
      end

      # Retrieve all sources
      def find_sources(headers=header_basic_auth)
        puts "Retrieving all sources"
        get("/sources", headers)
      end

      def retrieve_source(name, parameters={}, headers=default_headers)
        puts "Retrieving source named \"#{name}\""
        get("/sources/#{url_encode(name)}", parameters, headers)
      end

      def add_policy_rule_to_source(policy_rule_type, policy_rule_name, source_name, headers=default_headers)
        body = { "type" => policy_rule_type, "name" => policy_rule_name }
        puts "Adding policy rule \"#{policy_rule_type} - #{policy_rule_name}\" to source \"#{source_name}\""
        post("/sources/#{url_encode(source_name)}/policyRules", body, headers)
      end

      def remove_policy_rule_from_source(policy_rule_type, policy_rule_name, source_name, headers=default_headers)
        puts "Removing policy rule \"#{policy_rule_type} - #{policy_rule_name}\" from source \"#{source_name}\""
        delete("/sources/#{url_encode(source_name)}/policyRules/#{url_encode(policy_rule_type)}/#{url_encode(policy_rule_name)}", headers)
      end

    end
  end
end
