module ShowOff
  class Metadata

    class Assignment

      def match?(term)
        term =~ /.+=.+/
      end

      def apply(term,hash)
        key, value = parse(term)
        hash[key] = value
        hash
      end

      private

      def parse(term)
        term.split('=')
      end

    end

  end
end