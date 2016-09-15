module Kinetic
  module TaskApiV2
    class SDK

      def create_source(slug, source_web_server, headers=default_headers)
        name = slug
        body = {
          "name" => name,
          "status" => "Active",
          "type" => "Kinetic Request CE",
          "properties" => {
            "Space Slug" => slug,
            "Web Server" => source_web_server,
            "Proxy Username" => @custom['source']['user']['username'],
            "Proxy Password" => @custom['source']['user']['password']
          },
          "policyRules" => []
        }
        puts "Adding the #{name} source"
        post("/sources", body, headers)
      end

    end
  end
end
