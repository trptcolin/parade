module Parade
  module Renderers

    #
    # With the given HTML content, search for the CSS class for the HTML element
    # and when found generate columns for each element found. The size of the
    # columns is a division of the number of segments.
    #
    class ColumnsRenderer

      attr_accessor :css_class
      attr_accessor :html_element
      attr_accessor :segments

      #
      # @example Creating a ColumnsRenderer
      #
      # Creation of a column renderer that will look for slides with the class
      # 'columns', and create columns out of all h2 elements found, dividing
      # them across 12 elements.
      #
      #     ColumnsRenderer.new(:css_class => 'columns',:html_element => "h2",:segments => 12)
      #
      def initialize(params={})
        params.each {|k,v| send("#{k}=",v) if respond_to? "#{k}=" }
      end

      def render(content)

        html = Nokogiri::XML.fragment(content)

        html.css(".#{css_class}").each do |slide|

          columns = []
          slop = []

          chunks = slide.children.chunk {|child| child.name == html_element }

          slide.children = ""

          slide['class'] += " container_#{segments}"
          current_column = slide

          column_count = chunks.find_all {|is_column,contents| is_column }.count

          chunks.each do |is_column,contents|

            if is_column
              slide.add_child current_column unless current_column == slide
              current_column = Nokogiri::XML::Node.new('div',html)
              current_column['class'] = "grid_#{ segments / column_count }"
            end

            contents.each {|content| current_column.add_child content }
          end

          slide.add_child current_column

        end

        html.to_s

      end
    end

  end
end