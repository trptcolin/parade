require_relative 'presentation_directory_parser'
require_relative 'presentation_file_parser'
require_relative 'slides_file_content_parser'

module Parade
  module Parsers

    class PresentationFilepathParser

      def self.parse(filepath,options = {})
        return nil unless File.exists? filepath

        if File.directory? filepath
          PresentationDirectoryParser.parse filepath, options
        else

          if presentation_file?(filepath)
            PresentationFileParser.parse filepath, options
          else
            SlidesFileContentParser.parse filepath, options
          end

        end

      end


      def self.presentation_file?(filepath)
        File.basename(filepath) == "parade"
      end

    end

  end
end