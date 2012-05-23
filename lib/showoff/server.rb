require_relative "parsers/dsl"
require_relative 'renderers/update_image_paths'

require_relative 'features/live_ruby'
require_relative 'features/pdf_presentation'
require_relative 'features/preshow'

module ShowOff

  class Server < Sinatra::Application

    set :views, File.dirname(__FILE__) + '/../views'
    set :public_folder, File.dirname(__FILE__) + '/../public'

    set :verbose, false

    set :presentation_directory do
      File.expand_path Dir.pwd
    end

    set :presentation_file, 'showoff'


    def initialize(app=nil)
      super(app)
      require_ruby_files
    end

    def require_ruby_files
      Dir.glob("#{settings.presentation_directory}/*.rb").map { |path| require path }
    end

    def load_presentation
      root_node = Parsers::PresentationDirectoryParser.parse settings.presentation_directory,
        :root_path => settings.presentation_directory, :showoff_file => settings.presentation_file

      root_node.add_post_renderer Renderers::UpdateImagePaths.new :root_path => settings.presentation_directory
      root_node
    end

    helpers do

      def css(filepath)
        %{<link rel="stylesheet" href="css/#{filepath}" type="text/css"/>}
      end

      def js(filepath)
        %{<script type="text/javascript" src="js/#{filepath}"></script>}
      end

      def asset_path
        "./"
      end

      def css_files
        Dir.glob("#{settings.presentation_directory}/*.css").map { |path| File.basename(path) }
      end

      def js_files
        Dir.glob("#{settings.presentation_directory}/*.js").map { |path| File.basename(path) }
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

    end

    get %r{(?:image|file)/(.*)} do
      path = params[:captures].first
      full_path = File.join(settings.presentation_directory, path)
      send_file full_path
    end

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
