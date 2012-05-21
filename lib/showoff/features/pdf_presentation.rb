module ShowOff
  module PDFPresentation
    def self.included(server)

      server.get '/pdf' do
        
        # TODO: Find the presentation file and/or regenerate it every time
        
        html_content = erb :onepage

        # TODO the image references here are not full filepaths. creating issues

        kit = PDFKit.new(html_content,:page_size => 'Letter', :orientation => 'Landscape')

        ['reset.css','showoff.css','theme/ui.all.css','ghf_marked.css','onepage.css','pdf.css'].each do |css_file|
          kit.stylesheets << File.join(File.dirname(__FILE__),"..","..","public","css",css_file)
        end

        send_file kit.to_file('presentation.pdf')
      end

    end
  end
end