require_relative 'metadata'
require_relative 'renderers/html_with_pygments'
require_relative 'renderers/command_line_renderer'
require_relative 'renderers/special_paragraph_renderer'
require_relative 'renderers/columns_renderer'

module ShowOff

  #
  # The Slide is the core class of the Presentation. The slide aggregates the
  # markdown content, the slide metadata, and the slide template to create the
  # HTML representation of the slide for ShowOff.
  #
  class Slide

    # TODO: Previously this was #{name}#{sequence}, this is likely needing to be set
    # by the slideshow itself to ensure that the content is unique and displayed
    # in the correct order.
    attr_accessor :sequence

    attr_accessor :section

    def title
      section ? section.title : "Slide"
    end

    def reference
      "#{section ? section.title : 'slide'}/#{sequence}"
    end

    #
    # @param [Hash] params contains the parameters to help create the slide
    #   that is going to be displayed.
    #
    def initialize(params={})
      @content = ""
      @metadata = Metadata.new
      params.each {|k,v| send("#{k}=",v) if respond_to? "#{k}=" }
    end

    # The raw, unformatted slide content.
    attr_reader :content

    #
    # @param [String] value this is the new content initially is set or overrides
    #   the existing content within the slide
    #
    def content=(value)
      @content = "#{value}\n"
    end

    #
    # @param [String] append_raw_content this is additional raw content to add
    #   to the slide.
    #
    def <<(append_raw_content)
      @content << "#{append_raw_content}\n"
    end

    #
    # @return [Boolean] true if the slide has no content and false if the slide
    #   has content.
    def empty?
      @content.to_s.strip == ""
    end

    #
    # A slide can contain various metadata to help define additional information
    # about it.
    #
    # @param [ShowOff::Metadata] value metadata object which contains
    #   information for the slide
    #
    attr_accessor :metadata
    
    # @return [String] the CSS classes for the slide
    def slide_classes
      title.downcase.gsub(' ','-')
    end

    # @return [String] the CSS classes for the content section of the slide
    def content_classes
      metadata.classes.join(" ")
    end

    # @return [String] the transition style for the slide
    def transition
      metadata.transition || "none"
    end

    # @return [String] an id for the slide
    def id
      metadata.id.to_s
    end

    def pre_renderers
      [ Renderers::HTMLwithPygments ]
    end

    def post_renderers
      [ Renderers::SpecialParagraphRenderer,
        # Renderers::CommandLineRenderer,
        Renderers::ColumnsRenderer.new(:css_class => 'columns',:html_element => "h2",:segments => 12) ]
    end

    # @return [String] HTML rendering of the slide's raw contents.
    def content_as_html
      pre_renderers.inject(content) {|content,renderer| renderer.render(content) }
    end

    def slides
      self
    end

    # @return [ERB] an ERB template that this slide will be rendered into
    def template_file
      erb_template_file = section.template metadata.template
      ERB.new File.read(erb_template_file)
    end

    # @return [String] the HTML representation of the slide
    def to_html
      content = template_file.result(binding)
      post_renderers.inject(content) {|content,renderer| renderer.render(content) }
    end

  end
end