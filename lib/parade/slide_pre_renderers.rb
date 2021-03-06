require_relative 'renderers/html_with_pygments'

module Parade

  module SlidePreRenderers
    extend self

    def register(renderer)
      renderers.push renderer
    end

    def renderers
      @renderers ||= []
    end
  end

  SlidePreRenderers.register Renderers::HTMLwithPygments

end