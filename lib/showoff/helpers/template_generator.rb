require 'ostruct'

module ShowOff

  #
  # TemplateGenator uses ERB to generate a template and uses itself as the 
  # reference as the binding. This template generator is being used primarily
  # as a way to generate static versions of the content in HTML.
  # 
  # When created an :erb_template_file needs to be specified in the Hash, all
  # other fields are dependent on what is contained within the template itself
  # 
  class TemplateGenerator < OpenStruct

    #
    # @param [String,Symbol] type js for javascript, css for stylesheets
    # @param [String] filepath the filepath to load
    #
    def asset_template(type,filepath)
      InlineAssetTemplateGenerator.new :type => type, :filepath => filepath
    end

    #
    # Return javascript to be inlined in a template
    #
    # @param [String] filepath the filepath to the javascript file
    # @return [String] HTML content that is inlined javascript data
    def js(filepath)
      asset_template(:js,filepath).render
    end

    #
    # Return stylesheet to be inlined in a template
    #
    # @param [String] filepath the filepath to the stylesheet file
    # @return [String] HTML content that is inlined stylesheet data
    #
    def css(filepath)
      asset_template(:css,filepath).render
    end

    #
    # To provide support of having references to other templates, this will
    # handle erb method calls and in-line that template's content
    #
    # @param [Strign] filepath the filepath to another template
    # @return [String] HTML content of the specfied template at the filepath
    #
    def erb(filepath)
      template_filepath = File.join File.dirname(erb_template_file), "#{filepath}.erb"
      template_file = ERB.new File.read(template_filepath)
      template_file.result(binding)
    end

    #
    # @return [Types] the HTML content of the template specified
    # 
    def render
      template_file = ERB.new File.read(erb_template_file)
      template_file.result(binding)
    end
  end

  #
  # Provides a way to inline particular assets witin the content. This is used
  # to inline the javascript and css.
  # 
  class InlineAssetTemplateGenerator < TemplateGenerator

    def content
      content_filepath = File.join File.dirname(__FILE__), "..", "..", "public", type.to_s, filepath
      File.read content_filepath
    end

    def erb_template_file
      File.join File.dirname(__FILE__), "..", "..", "views", "inline_#{type}.erb"
    end

  end

end