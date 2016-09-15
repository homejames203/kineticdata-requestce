require 'erb'

module Kinetic
  module TaskApiV2
    class SDK

      # Replaces spaces with %20
      def url_encode(parameter)
        ERB::Util.url_encode parameter
      end

    end
  end
end
