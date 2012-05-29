
module ShowOff
  module Commands

    class Unknown

      def name
        "Unknown"
      end

      def description
        "Could not find the command specified"
      end

      def generate(options)
        puts "#{name} - #{description}"
      end

    end

  end
end