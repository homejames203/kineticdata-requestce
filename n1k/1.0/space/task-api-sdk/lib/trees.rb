module Kinetic
  module TaskApiV2
    class SDK

      # Delete a tree.
      #
      # Attributes
      #
      # +tree+ - either the tree title, or a map of component names
      # +headers+ - hash of headers to send, default is basic authentication
      #
      # Examples
      #
      # - delete_tree("Kinetic Request CE :: Win a Car :: Complete")
      #
      # - delete_tree({
      #       "source_name" => "Kinetic Request CE",
      #       "group_name" => "Win a Car",
      #       "tree_name" => "Complete"
      #     })
      #
      def delete_tree(tree, headers=header_basic_auth)
        if tree.is_a? Hash
          title = "#{tree['source_name']} :: #{tree['group_name']} :: #{tree['tree_name']}"
        else
          title = "#{tree.to_s}"
        end
        puts "Deleting Tree \"#{title}\""
        delete("/trees/#{url_encode(title)}", headers)
      end

      # Delete trees.
      #
      # If the source_name is provided, only trees that belong to the source
      # will be deleted, otherwise all trees will be deleted.
      #
      # Attributes
      #
      # +source_name+ - the name of the source, or nil to delete all trees
      # +headers+ - hash of headers to send, default is basic authentication
      #
      # Examples
      #
      # - delete_trees("Kinetic Request CE")
      #
      def delete_trees(source_name=nil, headers=header_basic_auth)
        if source_name.nil?
          puts "Deleting all trees"
          params = {}
        else
          puts "Deleting trees for Source \"#{source_name}\""
          params = { "source" => source_name }
        end

        find_trees(params, headers).each do |tree_json|
          tree = JSON.parse(tree_json)
          delete("/trees/#{url_encode(tree['title'])}", headers)
        end
      end


      # Get a list of trees.
      #
      # Attributes
      #
      # +params+ - Query parameters to add to the URL, such as +include+
      # +headers+ - hash of headers to send, default is basic authentication
      #
      # Examples
      #
      # - find_trees({ "source" => "Kinetic Request CE" })
      # - find_trees({ "include" => "details" })
      # - find_trees({ "source" => "Kinetic Request CE", "include" => "details" })
      #
      def find_trees(params={}, headers=header_basic_auth)
        puts "Retrieving Trees"
        get("/trees", params, headers)
      end

      # Import a tree
      #
      # If the tree already exists on the server, this will fail unless forced
      # to overwrite.
      #
      # The source named in the tree content must also exist on the server, or
      # the import will fail.
      #
      # Attributes
      #
      # +tree+ - content from tree file
      # +force_overwrite+ - whether to overwrite a tree if it exists, default is false
      # +headers+ - hash of headers to send, default is basic authentication
      def import_tree(tree, force_overwrite=false, headers=header_basic_auth)
        body = { "content" => tree }
        puts "Importing Tree #{File.basename(tree)}"
        post_multipart("/trees?force=#{force_overwrite}", body, headers)
      end

      # Import a routine
      #
      # If the routine already exists on the server, this will fail unless
      # forced to overwrite.
      #
      # Attributes
      #
      # +routine+ - content from routine file
      # +force_overwrite+ - whether to overwrite a routine if it exists, default is false
      # +headers+ - hash of headers to send, default is basic authentication
      def import_routine(routine, force_overwrite=false, headers=header_basic_auth)
        body = { "content" => routine }
        puts "Importing Routine #{File.basename(routine)}"
        post_multipart("/trees?force=#{force_overwrite}", body, headers)
      end

      # Retrieve a single tree by title (Source Name :: Group Name :: Tree Name)
      #
      # Attributes
      #
      # +title+ - The tree title
      # +params+ - Query parameters to add to the URL, such as +include+
      # +headers+ - hash of headers to send, default is basic authentication
      #
      # Examples
      #
      # retrieve_tree("Kinetic Request CE :: Win a Car :: Complete",
      #               { "include" => "details" })
      #
      def retrieve_tree(title, params={}, headers=header_basic_auth)
        puts "Retrieving the \"#{title}\" Tree"
        title = url_encode(title)
        get("/trees/#{title}", params, headers)
      end

    end
  end
end
