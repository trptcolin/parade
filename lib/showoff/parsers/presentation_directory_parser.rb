require_relative 'presentation_file_parser'
require_relative 'slides_file_content_parser'

module ShowOff
  module Parsers

    module PresentationDirectoryParser

      SLIDE_SEARCH_PATTERN = File.join('**','*.md')

      def self.parse(filepath,options = {})

        showoff_file = Array(options[:showoff_file]).find do |relative_filepath|
          showoff_file = File.join(filepath,relative_filepath)
          File.exists? showoff_file
        end
        
        if showoff_file
          PresentationFileParser.parse File.join(filepath,showoff_file), options
        else

          slides = Dir[File.join(filepath,SLIDE_SEARCH_PATTERN)].map do |slide_filepath|
            SlidesFileContentParser.parse slide_filepath, options
          end

          section = Section.new
          section.add_section slides
          section

        end
      end

    end

  end
end
