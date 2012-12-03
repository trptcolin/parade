
module Parade
  module Commands

    #
    # The Unknown Command is provided as the default for the command lists
    # as a default to ensure that a nil is not returned, allowing a for
    # an object that adheres to the generate method.
    # 
    class Unknown

      def description
        "Could not find the command specified"
      end

      def generate(options)
        puts description
      end

    end

  end
end