module ShowOff
  class Metadata

    class CSSClasses

      def match?(term)
        true
      end

      def apply(term,hash)
        (hash[:classes] ||= []) << term
        hash
      end

    end

  end
end