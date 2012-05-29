require_relative '../renderers/inline_images'

module ShowOff
  module Commands

    class StaticHtml

      def name
        "html"
      end

      def description
        "Output into a single HTML file"
      end

      def generate(options)
        options.merge!('template' => 'onepage')
        html_content = html_from_template(options)

        output_file = options[:output] || default_html_output

        return if (File.exists?(output_file) and not options.key?(:force))

        File.open(output_file,'w') {|file| file.puts html_content }

        puts "Saved HTML to #{output_file}"
      end

      private

      def html_from_template(options)
        filepath = options['filepath']

        return unless File.exists? filepath

        if File.directory? filepath
          root_path = filepath
          root_node = Parsers::PresentationDirectoryParser.parse filepath, :root_path => ".",
            :showoff_file => (Array(options['showoff_file']) + [ "showoff", "showoff.json" ]).compact.uniq
        else
          root_path = File.dirname filepath
          root_node = Parsers::PresentationFileParser.parse filepath, :root_path => root_path
        end

        root_node.add_post_renderer Renderers::InlineImages

        template_options = {  'erb_template_file' => File.join(File.dirname(__FILE__), "..", "..", "views", "#{options['template']}.erb"),
                              'custom_asset_path' => root_path,
                              'slides' => root_node.to_html }

        render_template template_options
      end

      def render_template(options)
        template = TemplateGenerator.new options
        template.render
      end

      def default_html_output
        "presentation.html"
      end

    end


  end
end
