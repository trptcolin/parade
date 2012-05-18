require_relative 'presentation_directory_parser'
require_relative 'presentation_file_parser'
require_relative 'slides_file_content_parser'

module ShowOff
  module Parsers

    class PresentationFilepathParser

      def self.parse(filepath)

        return nil unless File.exists? filepath

        if File.directory? filepath
          PresentationDirectoryParser.parse filepath
        else

          if presentation_file?(filepath)
            PresentationFileParser.parse filepath
          else
            SlidesFileContentParser.parse filepath
          end

        end

      end


      def self.presentation_file?(filepath)
        File.basename(filepath) == "showoff"
      end

    end

  end
end