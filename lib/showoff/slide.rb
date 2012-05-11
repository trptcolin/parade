module ShowOff

  #
  #
  class Slide

    # TODO: Previously this was #{name}#{sequence}, this is likely needing to be set
    # by the slideshow itself to ensure that the content is unique and displayed
    # in the correct order.
    attr_accessor :sequence

    def reference
      "slide/#{sequence}"
    end

    # Additional metadata about the slide can be provided here to help
    # construct the slide with the correct classes, ids, transitions, etc.
    attr_accessor :metadata

    # The raw, unformatted slide content.
    attr_accessor :content

    #
    # @param [Hash] params contains the parameters to help create the slide
    #   that is going to be displayed.
    #
    def initialize(params={})
      @content = ""
      params.each {|k,v| send("#{k}=",v) if respond_to? "#{k}=" }
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

    # @return [String] the CSS classes for the slide
    def classes
      metadata_classes = metadata.split(' ').delete_if {|i| i =~ /^(transition=.+)|^#/ }
      (metadata_classes + ['content']).join(" ")
    end

    # @return [String] the transition style for the slide
    def transition
      parsed_transition = metadata[/.*transition=(.+).*/,1].to_s.gsub('>','')
      parsed_transition.empty? ? "none" : parsed_transition
    end

    # @return [String] an id for the slide
    def id
      metadata.split(' ').find {|i| i =~ /^#.+/ }.to_s[1..-1]
    end

    # @return [String] HTML rendering of the slide's raw contents.
    def content_as_html
      markdown = Redcarpet::Markdown.new(Renderers::HTMLwithPygments,
        :fenced_code_blocks => true,
        :no_intra_emphasis => true,
        :autolink => true,
        :strikethrough => true,
        :lax_html_blocks => true,
        :superscript => true,
        :hard_wrap => true,
        :tables => true,
        :xhtml => true)
      markdown.render(content.to_s)
    end

    # @return [ERB] an ERB template that this slide will be rendered into
    def template_file
      erb_template_file = File.join File.dirname(__FILE__), "..", "views", "slide.erb"
      ERB.new File.read(erb_template_file)
    end

    # @return [String] the HTML representation of the slide
    def to_html
      template_file.result(binding)
    end

  end
end