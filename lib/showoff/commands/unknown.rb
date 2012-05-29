
module ShowOff
  module Commands

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