require_relative 'static_html'
require_relative 'static_pdf'
require_relative 'unknown'
require_relative 'generate_presentation'
require_relative 'generate_outline'
require_relative 'generate_rackup'

module ShowOff
  module Commands

    class Commands

      def self.commands_with_unknown_default
        command_hash = {}
        command_hash.default = Unknown.new
        command_hash
      end

      def self.static(name,command=nil)
        @statics ||= commands_with_unknown_default

        if command
          @statics[name] = command
        else
          @statics[name]
        end
      end

      def self.statics
        @statics
      end

      static "html", StaticHtml.new
      static "pdf", StaticPdf.new


      def self.generator(name,command=nil)
        @generators ||= commands_with_unknown_default
        if command
          @generators[name] = command
        else
          @generators[name]
        end
      end

      def self.generators
        @generators
      end

      generator "presentation", GeneratePresentation.new
      generator "outline", GenerateOutline.new
      generator "rackup", GenerateRackup.new

    end

  end
end