require 'base64'

module ShowOff
  module Renderers

    #
    # This Renderer will inline the images into content output. Allowing you
    # to create portable documents.
    #
    module InlineImages

      def self.render(content,options = {})

        content.gsub(/img src="\/?([^\/].*?)"/) do |image_source|
          image_name = Regexp.last_match(1)

          type, data = image_data(image_name)

          if type and data
            %{img src="data:image/#{type};base64,#{data}"}
          else
            image_source
          end
        end

      end

      def self.image_data
        $stderr.puts "Please install `rmagick` to allow images to be included in content"
        nil
      end

      if defined?(Magick)
        def self.image_data(path)
          magick_image = Magick::Image.read(path).first
          [ magick_image.format, Base64.encode64(magick_image.to_blob) ]
        end
      end


    end
  end
end