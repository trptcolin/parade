module Parade
  class Metadata

    #
    # By default the CSS Class metadata parser is a catch all parser that will
    # use all the terms and create CSS classes.
    # 
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