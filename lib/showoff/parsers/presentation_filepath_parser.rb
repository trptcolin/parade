require_relative 'presentation_directory_parser'
require_relative 'presentation_file_parser'

module ShowOff
  module Parsers

    class PresentationFilepathParser

      def self.parse(filepath)

        return nil unless File.exists? filepath

        if File.directory? filepath
          Parsers::PresentationDirectoryParser.parse filepath
        else
          Parsers::PresentationFileParser.parse filepath
        end

      end

    end

  end
end