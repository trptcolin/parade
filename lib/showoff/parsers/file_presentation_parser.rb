module ShowOff
  module Parsers

    class FilePresentationParser
      def self.parse(filepath)
        outline_data = JSON.parse(File.read(filepath))
        outline_data.merge!(:filepath => filepath)
        ShowOff::Outline.new outline_data
      end
    end

  end
end
