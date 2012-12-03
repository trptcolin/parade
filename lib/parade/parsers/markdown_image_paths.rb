module Parade
  module Parsers

    #
    # Within the markdown file the image paths are relative to the markdown
    # file. This parser will convert any image paths specified within the
    # markdown and convert them to relative to the presentation root.
    #
    # This parsing functionality ensures that the image path when this is
    # later rendered to HTML will have the correct path.
    #
    # @example ![octocat](octocat.png)
    #
    #     "![octocat](octocat.png)" # => "![octocat](section/octocat.png)"
    #
    class MarkdownImagePaths

      #
      # Convert all the image paths within the markdown content with the
      # specified path parameter.
      #
      # @example Update all image paths to be prefixed with 'section'
      #
      #     MarkdownImagePaths.parse(markdown_content, :path => 'section')
      #
      #
      # @param [String] content markdown content that may or may not contain
      #   image tags.
      # @param [Hash] options that contains parameters to help to properly
      #   convert the image path.
      #
      def self.parse(content,options = {})
        return content unless options[:path]

        content.gsub(/!\[([^\]]*)\]\((?!https?:\/\/)(.+)\)/) do |match|
          updated_image_path = File.join(options[:path],$2)
          %{![#{$1}](#{updated_image_path})}
        end

      end
    end

  end
end