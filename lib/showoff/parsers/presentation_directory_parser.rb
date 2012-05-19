require_relative 'presentation_file_parser'
require_relative 'slides_file_content_parser'

module ShowOff
  module Parsers

    module PresentationDirectoryParser

      DEFAULT_PRESENTATION_FILE = 'showoff'
      SLIDE_SEARCH_PATTERN = File.join('**','*.md')

      def self.parse(filepath,options = {})
        showoff_file = File.join(filepath,DEFAULT_PRESENTATION_FILE)

        if File.exists?(showoff_file)
          PresentationFileParser.parse showoff_file, options
        else

          Dir[File.join(filepath,SLIDE_SEARCH_PATTERN)].map do |slide_filepath|
            SlidesFileContentParser.parse slide_filepath, options
          end

        end
      end

    end

  end
end
