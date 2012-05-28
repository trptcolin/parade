module ShowOff
  module Parsers

    #
    # Load the JSON format of a presentation, convert it to the DSL format,
    # and then send it to the DSL parser.
    #
    # @example showoff.json format
    #
    #     {
    #       "name": "Something",
    #       "description": "Example Presentation",
    #       "templates" : { "default" : "custom.tpl" },
    #       "sections": [
    #         {"section":"one"},
    #         {"section":"two"},
    #         {"section":"three"}
    #       ]
    #     }
    #
    class JsonFileParser

      def self.parse(filepath,options = {})
        showoff_json = JSON.parse File.read(filepath)

        dsl_content = convert_to_showoff_dsl showoff_json
        Dsl.parse dsl_content, options
      end

      private

      def self.convert_to_showoff_dsl(content)

        dsl_content = ""

        dsl_content << "title '#{content['name']}'\n" if content['name']
        dsl_content << "description %{#{content['description']}}\n" if content['description']
        dsl_content << "pause_message %{#{content['pause_msg']}}" if content['pause_msg']

        templates = content['templates'] || {}

        templates.each do |template_name,template_file|
          dsl_content << "template '#{template_name}', '#{template_file}'\n"
        end

        Array(content['sections']).each do |section|

          if section.is_a?(Hash)
            filename_or_folder = section['section']
          else
            filename_or_folder = section
          end

          Array(filename_or_folder).each do |file_or_folder|
            dsl_content << "slides '#{file_or_folder}'\n"
          end
        end

        dsl_content

      end

    end

  end
end