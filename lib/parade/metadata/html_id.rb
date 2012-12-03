module Parade
  class Metadata

    #
    # Specify the HTML id of the slide through this metadata parser. This allows
    # the id to be defined like one would reference with jQuery.
    #
    # @example Setting the Metadata id
    #
    #     metadata = Metadata.parse "transition=fade one two #id three tpl=template_name"
    #     metadata.id # => id
    #
    # @see Metadata
    #
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