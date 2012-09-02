require_relative "parsers/dsl"
require_relative 'renderers/update_image_paths'

require_relative 'features/live_ruby'
require_relative 'features/pdf_presentation'
require_relative 'features/preshow'

module ShowOff

  class Server < Sinatra::Application

    def initialize(app=nil)
      super(app)
      require_ruby_files
    end

    def require_ruby_files
      Dir.glob("#{settings.presentation_directory}/*.rb").map { |path| require path }
    end

    set :views, File.dirname(__FILE__) + '/../views'
    set :public_folder, File.dirname(__FILE__) + '/../public'

    set :verbose, false

    set :presentation_directory do
      File.expand_path Dir.pwd
    end

    set :presentation_file, 'showoff'

    set :default_presentation_files, [ 'showoff', 'showoff.json' ]

    def presentation_files
      (Array(settings.presentation_file) + settings.default_presentation_files).compact.uniq
    end

    def load_presentation
      root_node = Parsers::PresentationDirectoryParser.parse settings.presentation_directory,
        :root_path => settings.presentation_directory, :showoff_file => presentation_files

      root_node.add_post_renderer Renderers::UpdateImagePaths.new :root_path => settings.presentation_directory
      root_node
    end

    helpers do

      #
      # A shortcut to define a CSS resource file within a view template
      #
      def css(filepath)
        %{<link rel="stylesheet" href="css/#{filepath}" type="text/css"/>}
      end

      #
      # A shortcut to define a Javascript resource file within a view template
      #
      def js(filepath)
        %{<script type="text/javascript" src="js/#{filepath}"></script>}
      end

      #
      # Create resources links to all the CSS files found at the root of
      # presentation directory.
      #
      def custom_css_files
        load_presentation.resources.map do |resource_path|
          Dir.glob("#{resource_path}/*.css").map do |path|
            relative_path = path.sub(settings.presentation_directory,'file')
            css relative_path
          end.join("\n")
        end.join("\n")
      end

      #
      # Create resources links to all the Javascript files found at the root of
      # presentation directory.
      #
      def custom_js_files
        load_presentation.resources.map do |resource_path|
          Dir.glob("#{resource_path}/*.js").map do |path|
            relative_path = path.sub(settings.presentation_directory,'file')
            js relative_path
          end.join("\n")
        end.join("\n")
      end

      def presentation
        load_presentation
      end

      def title
        presentation.title
      end

      def slides
        presentation.to_html
      end

      def pause_message
        presentation.pause_message
      end
    end

    #
    # Path requests for files that match the prefix will be returned.
    #
    get %r{(?:image|file)/(.*)} do
      path = params[:captures].first
      full_path = File.join(settings.presentation_directory, path)
      send_file full_path
    end

    #
    # The request for slides is used by the client-side javascript presentation
    # and returns all the slides HTML.
    #
    get "/slides" do
      slides
    end

    get "/" do
      erb :index
    end

    get "/presenter" do
      erb :presenter
    end

    get "/onepage" do
      erb :onepage
    end

    include LiveRuby
    include PDFPresentation
    include Preshow

  end

end
