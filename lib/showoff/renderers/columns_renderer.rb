module ShowOff
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
        parser = CommandlineParser.new

        html.css(".#{css_class}").each do |slide|

          columns = []
          slop = []

          slide.children.each do |child|

            if child.name == html_element
              columns <<  Nokogiri::XML::Node.new('div',html)
            end

            if columns.last
              columns.last.add_child(child)
            else
              slop << child
            end

          end

          slide['class'] += " container_#{segments}"

          columns.each do |column|
            column['class'] = "grid_#{ segments / columns.count }"
          end

          slide.children = (slop + columns).map {|c| c.to_s }.join("\n")

        end


        html.to_s

      end
    end

  end
end