module ShowOff
  module Renderers

    #
    # UpdateImagePaths is used to ensure the img source paths in the HTML
    # content is properly prefaced with the "image" path as that is necessary
    # for the Sinatra server to properly know that it is to return an image.
    # 
    # Additional processing of the image is provided if RMagick has been 
    # installed. Namely it sets the size correctly.
    #
    class UpdateImagePaths
      
      #
      # @param [String] content HTML content that is parsed for image srcs
      # @param [Hash] options additional parameters, at the moment it is unused.
      #
      def self.render(content,options = {})

        content.gsub(/img src="\/?([^\/].*?)"/) do |image_source|
          html_image_path = File.join("/","image",$1)
          updated_image_source = %{img src="#{html_image_path}" }
          # w, h     = get_image_size(image_asset_path($1))
          # src << %( width="#{w}" height="#{h}") if w and h
          updated_image_source
        end
      end

      if defined?(Magick)

        def self.get_image_size(path)
          # unless cached_image_size.key?(path)
          #   # @asset_path
          #   # image_path = File.join(File.dirname(filepath),path)
          #   image = Magick::Image.ping(path).first
          #   # don't set a size for svgs so they can expand to fit their container
          #   if image.mime_type == 'image/svg+xml'
          #     cached_image_size[path] = [nil, nil]
          #   else
          #     cached_image_size[path] = [image.columns, image.rows]
          #   end
          # end
          # cached_image_size[path]
        end

      else
        def self.get_image_size(path) ; end
      end

    end

  end
end