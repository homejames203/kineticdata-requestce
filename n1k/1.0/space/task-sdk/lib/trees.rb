module Kinetic
  module TaskApiV2
    class SDK

      # Get a list of trees.
      #
      # params = { "source" => "Kinetic Request CE" }
      # params = { "include" => "details" }
      def find_trees(params={}, headers=header_basic_auth)
        puts "Retrieving Trees"
        get("/trees", params, headers)
      end

      # Retrieve a single tree by title (Source Name :: Group Name :: Tree Name)
      def retrieve_tree(title, params={}, headers=header_basic_auth)
        puts "Retrieving the \"#{title}\" Tree"
        title = url_encode(title)
        get("/trees/#{title}", params, headers)
      end

      # Import a tree file
      #
      # If the tree already exists on the server,
      # this will fail unless forced to overwrite
      def import_tree(tree, force_overwrite=false, headers=header_basic_auth)
        body = { "content" => tree }
        puts "Importing Tree #{File.basename(tree)}"
        post_multipart("/trees?force=#{force_overwrite}", body, headers)
      end

      def import_routine(routine, force_overwrite=false, headers=header_basic_auth)
        body = { "content" => routine }
        puts "Importing Routine #{File.basename(routine)}"
        post_multipart("/trees?force=#{force_overwrite}", body, headers)
      end

    end
  end
end
