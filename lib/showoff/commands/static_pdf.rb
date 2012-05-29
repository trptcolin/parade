require_relative 'html_output'

module ShowOff
  module Commands

    class StaticPdf

      def description
        "Output into a PDF format"
      end

      def generate(options)
        options.merge!('template' => 'pdf')

        html_generator = HtmlOutput.new
        html_content = html_generator.generate(options)

        kit = PDFKit.new(html_content,:page_size => 'Letter', :orientation => 'Landscape')

        output_file = options[:output] || default_pdf_output

        return if (File.exists?(output_file) and not options.key?(:force))

        kit.to_file(output_file)

        puts "Saved PDF to #{output_file}"
      end

      def default_pdf_output
        "presentation.pdf"
      end

    end

  end
end