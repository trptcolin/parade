require_relative 'presentation_file_parser'
require_relative 'slides_file_content_parser'

module Parade
  module Parsers

    module PresentationDirectoryParser

      SLIDE_SEARCH_PATTERN = File.join('**','*.md')

      def self.parse(filepath,options = {})

        parade_file = Array(options[:parade_file]).find do |relative_filepath|
          parade_file = File.join(filepath,relative_filepath)
          File.exists? parade_file
        end
        
        if parade_file
          PresentationFileParser.parse File.join(filepath,parade_file), options
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
