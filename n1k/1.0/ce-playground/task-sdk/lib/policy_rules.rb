module Kinetic
  module TaskApiV2
    class SDK

      # Create a policy Rule
      #
      # policy = {
      #   "name" => "Foo",
      #   "type" => "Console Access | Category Access | API Access | System Default",
      #   "rule" => "...",
      #   "message" => "..."
      # }
      def create_policy_rule(policy, headers=default_headers)
        type = policy.delete("type")
        puts "Creating policy rule \"#{type} - #{policy['name']}\""
        post("/policyRules/#{url_encode(type)}", policy, headers)
      end

    end
  end
end
