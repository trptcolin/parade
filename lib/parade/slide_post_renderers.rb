module Parade

  module SlidePostRenderers
    extend self

    def register(renderer)
      renderers.push renderer
    end

    def renderers
      @renderers ||= []
    end
  end

  SlidePostRenderers.register Renderers::SpecialParagraphRenderer
  SlidePostRenderers.register Renderers::CommandLineRenderer
  SlidePostRenderers.register Renderers::ColumnsRenderer.new(css_class: 'columns',
    html_element: "h2", segments: 12)

end