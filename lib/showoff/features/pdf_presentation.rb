module ShowOff

  module PDFPresentation
    def pdf
      @slides = presentation.to_html
      @no_js = false
      html = erb :onepage

      # TODO make a random filename

      # PDFKit.new takes the HTML and any options for wkhtmltopdf
      # run `wkhtmltopdf --extended-help` for a full list of options
      kit = PDFKit.new(html, ::ShowOffUtils.showoff_pdf_options(settings.presentation_directory))

      # Save the PDF to a file
      file = kit.to_file('/tmp/preso.pdf')
    end
  end


end