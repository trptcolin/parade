require_relative 'dsl_file_parser'
require_relative 'json_file_parser'

module ShowOff
  module Parsers
    
    #
    # The Presentation File Parser allows for the JSON formatted file or the
    # DSL formatted files. The determination of which to use is solely based
    # on the file extension.
    # 
    class PresentationFileParser

      def self.parse(filepath,options = {})
        options = options.merge(:current_path => File.dirname(filepath))
        
        if File.extname(filepath) == ".json"
          JsonFileParser.parse(filepath,options)
        else
          DslFileParser.parse(filepath,options)
        end
      end

    end

  end
end