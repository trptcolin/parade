module ShowOff
  class Metadata

    class HTMLId
      def match?(term)
        term =~ /#.+/
      end

      def apply(term,hash)
        hash[:id] = parse(term)
        hash
      end

      private

      def parse(term)
        term[1..-1]
      end

    end

  end
end