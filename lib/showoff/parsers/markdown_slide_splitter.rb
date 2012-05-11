module ShowOff
  module Parsers

    class MarkdownSlideSplitter

      #
      # Splits the markdown content into separate slide files based on the
      # separator defined by this class.
      #
      # @param [String] content content that is markdown format
      #
      def self.parse(content)

        # if there are no !SLIDE markers, then make every H1 define a new slide
        unless content =~ /^\<?!SLIDE/m
          content = content.gsub(/^# /m, "<!SLIDE>\n# ")
        end

        lines = content.split("\n")

        # Break the markdown apart into separate markdown files based on the
        # separator

        slides = []
        current_slide = Slide.new
        slides << current_slide

        until lines.empty?
          line = lines.shift

          if line =~ /^<?!SLIDE(.*)>?/
            current_slide = Slide.new(:metadata => $1)
            slides << current_slide
          else
            current_slide << line
          end

        end

        slides.delete_if {|slide| slide.empty? }
        slides.each_with_index {|slide,index| slide.sequence = (index + 1) }

      end
    end

  end
end