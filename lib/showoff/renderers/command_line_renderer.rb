require 'parslet'

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

    # For parsing commandline slide content.
    class CommandlineParser < Parslet::Parser

      rule(:prompt) do
        str('$') | str('#') | str('>>')
      end

      rule(:text) do
        match['[:print:]'].repeat
      end

      rule(:singleline_input) do
        (str("\\\n").absent? >> match['[:print:]']).repeat
      end

      rule(:input) do
        multiline_input | singleline_input
      end

      rule(:multiline_input) do

        # some command \
        # continued \
        # \
        # and stop
        ( singleline_input >> str('\\') >> newline ).repeat(1) >> singleline_input
      end

      rule(:command) do

        # $ some command
        # some output
        ( prompt.as(:prompt) >> space? >> input.as(:input) >> output? ).as(:command)
      end

      rule(:output) do

        # output
        prompt.absent? >> text
      end

      rule(:output?) do

        #
        # some text
        # some text
        #
        # some text
        ( newline >> ( ( output >> newline ).repeat >> output.maybe ).as(:output) ).maybe
      end

      rule(:commands) do
        command.repeat
      end

      rule(:newline) do
        str("\n") | str("\r\n")
      end

      rule(:space?) do
        match['[:space:]'].repeat
      end

      root(:commands)
    end

  end
end