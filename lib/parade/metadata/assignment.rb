module Parade
  class Metadata

    #
    # The Assignment metadata parser is a general parser that allows the ability
    # to assign a value to the specified field of the metadata. This is
    # usually used for assigning the *transition* field but could be used to set
    # the *id* in the metadata.
    #
    # @example Settings the Metadata id
    #
    #     metadata = Metadata.parse "id=unique-slide-id"
    #     metadata.id # => "unique-slide-id"
    #
    # @see Metadata
    #
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