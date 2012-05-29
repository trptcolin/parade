require_relative 'helpers/template_generator'
require_relative 'renderers/inline_images'
require_relative 'commands/commands'

module ShowOff

  module Utilities
    extend self
    
    def statics
      all_commands = ShowOff::Commands::Commands.statics.map {|command| [command.name, command.description] }.flatten
      Hash[*all_commands]
    end
    
    def static(output_type,options)
      puts "Generating #{output_type} with #{options}"
      command = ShowOff::Commands::Commands.static(output_type)
      command.generate(options)
    end

    def generators
      all_commands = ShowOff::Commands::Commands.generators.map {|command| [command.name, command.description] }.flatten
      Hash[*all_commands]
    end
    
    def generate(asset_name,options)
      puts "Generating #{asset_name} with #{options}"
      command = ShowOff::Commands::Commands.generator(asset_name)
      command.generate(options)
    end
  end

end