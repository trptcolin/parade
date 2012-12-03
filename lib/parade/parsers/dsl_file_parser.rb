module Parade
  module Parsers

    #
    # Given a DSL defined file, load the contents and then parse the contents
    # with the DSL parser.
    #
    class DslFileParser

      def self.parse(filepath,options = {})
        Dsl.parse File.read(filepath), options
      end

    end

  end
end