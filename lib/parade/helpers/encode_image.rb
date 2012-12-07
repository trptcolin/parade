require 'base64'

module Parade
  module Helpers

    module EncodeImage

      def image_path_to_base64
        $stderr.puts "Please install `rmagick` to allow images to be included in content"
        ''
      end

      if defined?(Magick)
        def image_path_to_base64(path)
          magick_image = Magick::Image.read(path).first
          data = Base64.encode64(magick_image.to_blob).gsub("\n",'').strip
          "data:image/#{magick_image.format};base64,#{data}"
        end
      end

    end

  end
end