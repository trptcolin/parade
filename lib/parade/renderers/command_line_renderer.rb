require 'parslet'

module Parade
  module Renderers

    #
    # Slides that have been marked as 'commandline' will be processed here to
    # ensure that the command portion is played out as if typed. Followed by
    # the result which appears after the command is completed.
    #
    # @example Slide marker to denote a command-line slide
    #
    #     !SLIDE commandline incremental
    #
    #
    # To denote the command, it needs to be prefaced with a `$`. The remaining
    # code is considered to be the result.
    #
    # @example Contents of a slide to show a command and a result
    #
    #     ```bash
    #     $ git commit -am 'incremental bullet points working'
    #     [master ac5fd8a] incremental bullet points working
    #      2 files changed, 32 insertions(+), 5 deletions(-)
    #     ```
    #
    class CommandLineRenderer

      #
      # @param [String] html_content the html content of a single slide that
      #   will have the commandline rendered correctly if it is a class on
      #   the slide.
      # @return [String] the same html content if there is no commandline class
      #   or the new rendered html content with the new required HTML elements.
      #
      def self.render(html_content)

        html = Nokogiri::HTML.fragment(html_content)
        parser = CommandlineParser.new

        html.css('.commandline pre').each do |code|
          out = code.text
          code.content = ''
          tree = parser.parse(out)
          transform = Parslet::Transform.new do
            rule(:prompt => simple(:prompt), :input => simple(:input), :output => simple(:output)) do
              command = Nokogiri::XML::Node.new('pre', html)
              command.set_attribute('class', 'command')

              node_prompt = Nokogiri::XML::Node.new('span', html)
              # The 'nv' class specifically gives it the same code syntax highlighting
              node_prompt.set_attribute('class','prompt nv')
              node_prompt.content = prompt

              separator = Nokogiri::XML::Text.new(' ',html)

              node_input = Nokogiri::XML::Node.new('span',html)
              node_input.content = input
              # The 'nb' class specifically gives it the same syntax highlighting
              node_input.set_attribute('class','input nb')

              command << node_prompt
              command << separator
              command << node_input

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

        html.to_s

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