require_relative 'helpers/template_generator'
require_relative 'renderers/inline_images'
require_relative 'commands/commands'

module ShowOff

  module Utilities
    extend self
    
    def static(output_type,options)
      puts "Generating #{output_type} with #{options}"
      command = ShowOff::Commands::Commands.static(output_type)
      command.generate(options)
    end

    def generate(asset_name,options)
      puts "Generating #{asset_name} with #{options}"
      command = ShowOff::Commands::Commands.generator(asset_name)
      command.generate(options)
    end
  end

end