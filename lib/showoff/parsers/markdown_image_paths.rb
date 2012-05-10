module ShowOff
  module Parsers

    class MarkdownImagePaths
      def self.parse(content,options = {})

        content.gsub(/!\[([^\]]*)\]\((.+)\)/) do |match|
          updated_image_path = File.join(options[:path],$2)
          %{![#{$1}](#{updated_image_path})}
        end

      end
    end

  end
end