
module Parade
  module Renderers

    #
    # This Renderer will inline the images into content output. Allowing you
    # to create portable documents.
    #
    module InlineImages

      def self.render(content,options = {})

        content.gsub(/img src=["']\/?([^\/].*?)["']/) do |image_source|
          image_name = Regexp.last_match(1)

          base64_data = image_path_to_base64(image_name)

          if base64_data
            %{img src="#{base64_data}"}
          else
            image_source
          end
        end

      end

      extend Parade::Helpers::EncodeImage

    end
  end
end