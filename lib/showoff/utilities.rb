require_relative 'helpers/template_generator'
require_relative 'renderers/inline_images'
require_relative 'commands/static_html'
require_relative 'commands/static_pdf'
require_relative 'commands/unknown'
require_relative 'commands/generate_presentation'
require_relative 'commands/generate_outline'
require_relative 'commands/generate_rackup'

module ShowOff

  module Utilities
    extend self

    def static_commands
      [ ShowOff::Commands::StaticHtml.new, ShowOff::Commands::StaticPdf.new ]
    end

    def static_command(name)
      all_commands = static_commands.map {|command| [ command.name, command ] }.flatten
      command_hash = Hash[*all_commands]
      command_hash.default = ShowOff::Commands::Unknown.new
      command_hash[name]
    end

    def statics
      all_commands = static_commands.map {|command| [command.name, command.description] }.flatten
      Hash[*all_commands]
    end

    def static(output_type,options)
      command = static_command(output_type)
      command.generate(options)
    end

    def generate_commands
      [ ShowOff::Commands::GeneratePresentation.new,
        ShowOff::Commands::GenerateOutline.new,
        ShowOff::Commands::GenerateRackup.new ]
    end

    def generators
      all_commands = generate_commands.map {|command| [command.name, command.description] }.flatten
      Hash[*all_commands]
    end
    
    def generator(name)
      all_commands = generate_commands.map {|command| [ command.name, command ] }.flatten
      command_hash = Hash[*all_commands]
      command_hash.default = ShowOff::Commands::Unknown.new
      command_hash[name]
    end
    
    def generate(asset_name,options)
      puts "Generating #{asset_name} with #{options}"
      command = generator(asset_name)
      command.generate(options)
    end
  end

end