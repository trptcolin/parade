require 'ostruct'

module ShowOff

  class TemplateGenerator < OpenStruct
  
    def render
      template_file = ERB.new File.read(erb_template_file)
      template_file.result(binding)
    end
  end

end