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

        rootpath = options[:rootpath] || "."

        content.gsub(/img src="\/?([^\/].*?)"/) do |image_source|
          html_image_path = File.join("/","image",$1)
          updated_image_source = %{img src="#{html_image_path}"}

          html_asset_path = File.join(rootpath,$1)
          width, height = get_image_size(html_asset_path)
          updated_image_source << %( width="#{width}" height="#{height}") if width and height

          updated_image_source
        end
      end

      if defined?(Magick)

        def self.get_image_size(path)
          unless cached_image_size.key?(path)

            image = Magick::Image.ping(path).first

            # # don't set a size for svgs so they can expand to fit their container
            if image.mime_type == 'image/svg+xml'
              cached_image_size[path] = [nil, nil]
            else
              cached_image_size[path] = [image.columns, image.rows]
            end

          end
          cached_image_size[path]
        end

        def self.cached_image_size
          @cached_image_size ||= {}
        end

      else
        def self.get_image_size(path) ; end
      end

    end

  end
end