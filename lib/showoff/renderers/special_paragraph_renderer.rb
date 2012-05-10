module ShowOff
  module Renderers

    class SpecialParagraphRenderer
      def self.render(html_content)
        html_content.gsub(/<p>\.(.*?) /, '<p class="\1">')
      end
    end

  end
end