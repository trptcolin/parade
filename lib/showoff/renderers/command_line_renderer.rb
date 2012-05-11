module ShowOff
  module Renderers

    class CommandLineRenderer

      def self.render(html_content)

        html = Nokogiri::XML.parse(html_content)
        parser = CommandlineParser.new

        html.css('.commandline pre').each do |code|
          out = code.text
          code.content = ''
          tree = parser.parse(out)
          transform = Parslet::Transform.new do
            rule(:prompt => simple(:prompt), :input => simple(:input), :output => simple(:output)) do
              command = Nokogiri::XML::Node.new('pre', html)
              command.set_attribute('class', 'command')
              command.content = "#{prompt} #{input}"
              code << command

              # Add newline after the input so that users can
              # advance faster than the typewriter effect
              # and still keep inputs on separate lines.
              code << "\n"

              unless output.to_s.empty?
                result = Nokogiri::XML::Node.new('pre', html)
                result.set_attribute('class', 'result')
                result.content = output
                code << result
              end

            end
          end
          transform.apply(tree)
        end

        html.root.to_s

      end

    end

  end
end