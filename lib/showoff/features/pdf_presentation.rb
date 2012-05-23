module ShowOff
  module PDFPresentation
    def self.included(server)

      server.get '/pdf' do
        
        # TODO: Find the presentation file and/or regenerate it every time
        
        template_options = {  'erb_template_file' => File.join(File.dirname(__FILE__), "..", "..", "views", "pdf.erb"),
                              'slides' => slides }
        
        html_content = TemplateGenerator.new(template_options).render
        
        # TODO the image references here are not full filepaths. creating issues

        kit = PDFKit.new(html_content,:page_size => 'Letter', :orientation => 'Landscape')

        send_file kit.to_file('presentation.pdf')
      end

    end
  end
end