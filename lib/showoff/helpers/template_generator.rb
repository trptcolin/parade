require 'ostruct'

module ShowOff

  class TemplateGenerator < OpenStruct

    def js(filepath)
      js_template = JSTemplateGenerator.new :filepath => filepath
      js_template.render
    end

    def css(filepath)
      css_template = CSSTemplateGenerator.new :filepath => filepath
      css_template.render
    end

    def erb(filepath)
      template_filepath = File.join File.dirname(erb_template_file), "#{filepath}.erb"
      template_file = ERB.new File.read(template_filepath)
      template_file.result(binding)
    end

    def render
      template_file = ERB.new File.read(erb_template_file)
      template_file.result(binding)
    end
  end


  class CSSTemplateGenerator < TemplateGenerator

    def content
      css_filepath = File.join File.dirname(__FILE__), "..", "..", "public", "css", filepath
      File.read css_filepath
    end

    def erb_template_file
      File.join File.dirname(__FILE__), "..", "..", "views", "inline_css.erb"
    end
  end

  class JSTemplateGenerator < TemplateGenerator

    def content
      js_filepath = File.join File.dirname(__FILE__), "..", "..", "public", "js", filepath
      File.read js_filepath
    end

    def erb_template_file
      File.join File.dirname(__FILE__), "..", "..", "views", "inline_js.erb"
    end
  end


end