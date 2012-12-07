module Parade
  module Renderers

    #
    # Within the markdown you are able to add additional formatting by starting
    # a new line with a period followed by the class name. This is commonly
    # used for writing presenter notes.
    #
    # @example Adding a presenter note within the markdown
    #
    #     ## This Slide has important details
    #     * Detail 1
    #     * Detail 2
    #     .notes Ensure that you talk about detail 1 the most!
    #
    class SpecialParagraphRenderer
      def self.render(html_content)
        html_content.gsub(/<p>\.(.*?) /, '<p class="\1">')
      end
    end

  end
end