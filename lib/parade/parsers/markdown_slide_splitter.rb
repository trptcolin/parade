require_relative '../slide'

module Parade
  module Parsers

    #
    # As multiple slides are contained within a markdown file, this parser
    # will split the markdown along the specified slide marker.
    #
    # @todo this currently does too much at the moment. It should simply split
    #   the markdown file along the slide markers and allow another parser
    #   perform the work of creating the actual slide objects.
    #
    class MarkdownSlideSplitter

      #
      # Splits the markdown content into separate slide files based on the
      # separator defined by this class.
      #
      # @param [String] content content that is markdown format
      # @return [Array] slides parsed from the markdown content
      def self.parse(content,options = {})

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

            # Remove the trailing > from the metadata
            metadata_string = Regexp.last_match(1).gsub(/>$/,'')

            metadata = Metadata.parse metadata_string

            current_slide = Slide.new(:metadata => metadata)
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