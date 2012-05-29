require_relative 'render_from_template'

require_relative 'static_html'
require_relative 'static_pdf'
require_relative 'unknown'
require_relative 'generate_presentation'
require_relative 'generate_outline'
require_relative 'generate_rackup'


module ShowOff
  module Commands

    def self.commands_with_unknown_default
      command_hash = {}
      command_hash.default = Unknown.new
      command_hash
    end

    def self.statics
      @statics ||= commands_with_unknown_default
    end

    def self.generators
      @generators ||= commands_with_unknown_default
    end

    def self.commands(type,name,command=nil)
      command_set = send(type)
      if command
        command_set[name] = command
      else
        command_set[name]
      end
    end

    def self.static(name,command=nil)
      commands :statics, name, command
    end

    def self.generator(name,command=nil)
      commands :generators, name, command
    end

    def self.execute(type,name,options)
      puts "Generating #{type} #{name} with #{options}"
      send(type,name).generate(options)
    end

    static "html", StaticHtml.new
    static "pdf", StaticPdf.new

    generator "presentation", GeneratePresentation.new
    generator "outline", GenerateOutline.new
    generator "rackup", GenerateRackup.new

  end
end