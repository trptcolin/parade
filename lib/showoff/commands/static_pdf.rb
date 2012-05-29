require_relative '../renderers/inline_images'

module ShowOff
  module Commands

    class StaticPdf
      include RenderFromTemplate

      def name
        "pdf"
      end

      def description
        "Output into a PDF format"
      end

      def generate(options)
        options.merge!('template' => 'pdf')

        html_content = html_from_template(options)
        kit = PDFKit.new(html_content,:page_size => 'Letter', :orientation => 'Landscape')

        output_file = options[:output] || default_pdf_output

        return if (File.exists?(output_file) and not options.key?(:force))

        kit.to_file(output_file)

        puts "Saved PDF to #{output_file}"
      end

      def default_pdf_output
        "presentation.pdf"
      end

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

        template_options = {  'erb_template_file' => File.join(default_view_path, "#{options['template']}.erb"),
                              'custom_asset_path' => root_path,
                              'slides' => root_node.to_html }

        render_template template_options
      end

    end

  end
end