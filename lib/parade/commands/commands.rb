require_relative 'render_from_template'

require_relative 'static_html'
require_relative 'static_pdf'
require_relative 'unknown'
require_relative 'generate_presentation'
require_relative 'generate_outline'
require_relative 'generate_rackup'


module Parade
  
  #
  # Commands is a module that contains commands to be used through the 
  # bin/parade utility. This module defines a number of helper methods to 
  # define generator and static content output formats.
  # 
  module Commands

    # @return [Hash] an empty command hash with the default, when a command is
    #   not found, to return the Unknown command.
    def self.commands_with_unknown_default
      command_hash = {}
      command_hash.default = Unknown.new
      command_hash
    end

    # @return [Hash] a hash that contains all the avaliable static output commands
    def self.statics
      @statics ||= commands_with_unknown_default
    end
    
    # @return [Hash] a hash that contains all the avaliable generator commands
    def self.generators
      @generators ||= commands_with_unknown_default
    end

    #
    # @param [String,Symbol] type the type of command (e.g. statics or generators)
    # @param [String] name the name which the command can be accessed
    # @param [Object#description,Object#generate] command the command itself, which
    #   adheres to the two methods {#description} and {#generate}
    #
    def self.commands(type,name,command=nil)
      command_set = send(type)
      if command
        command_set[name] = command
      else
        command_set[name]
      end
    end

    # Find or create a static output command. Creates a static output entry
    # if the command is provided.
    def self.static(name,command=nil)
      commands :statics, name, command
    end

    # Find or create a generator command. Creates a static output entry if the 
    # command is provided.
    def self.generator(name,command=nil)
      commands :generators, name, command
    end

    #
    # @param [String,Symbol] type the typw of command (e.g. statics or generators)
    # @param [String] name the name of the command to be found of the specified type
    # @param [Hash] options a Hash of options that help instruct the execution
    #   process.
    #
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