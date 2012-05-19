require_relative "../showoff_utils"
require_relative "parsers/dsl"
require_relative 'renderers/update_image_paths'

module ShowOff

  class Server < Sinatra::Application

    set :views, File.dirname(__FILE__) + '/../views'
    set :public_folder, File.dirname(__FILE__) + '/../public'

    set :verbose, false
    set :presentation_directory, '.'
    set :pres_file, 'showoff'

    def logger
      @logger ||= begin
        log = Logger.new(STDOUT)
        log.formatter = proc { |severity,datetime,progname,msg| "#{progname} #{msg}\n" }
        log.level = settings.verbose ? Logger::DEBUG : Logger::WARN
        log
      end
    end

    def debug(message)
      logger.debug(message)
    end

    def presentation
      pres_filepath = File.join(settings.presentation_directory,settings.pres_file)
      contents = File.read pres_filepath
      root_section = Parsers::Dsl.parse contents, :root_path => pres_filepath

      root_section.add_post_renderer Renderers::UpdateImagePaths.new :root_path => File.dirname(pres_filepath)
      root_section
    end

    def initialize(app=nil)
      super(app)

      settings.presentation_directory ||= Dir.pwd
      settings.presentation_directory = File.expand_path(settings.presentation_directory)

      require_ruby_files

      @root_path = "."
      @pres_name = settings.presentation_directory.split('/').pop
      @asset_path = "./"
    end

    def self.pres_dir_current
      opt = {:pres_dir => Dir.pwd}
      ShowOff.set opt
    end

    def require_ruby_files
      Dir.glob("#{settings.presentation_directory}/*.rb").map { |path| require path }
    end

    helpers do

      def css_files
        Dir.glob("#{settings.presentation_directory}/*.css").map { |path| File.basename(path) }
      end

      def js_files
        Dir.glob("#{settings.presentation_directory}/*.js").map { |path| File.basename(path) }
      end

      def preshow_files
        Dir.glob("#{settings.presentation_directory}/_preshow/*").map { |path| File.basename(path) }.to_json
      end

      def inline_css(csses, pre = nil)
        css_content = '<style type="text/css">'
        csses.each do |css_file|
          if pre
            css_file = File.join(File.dirname(__FILE__), '..', pre, css_file)
          else
            css_file = File.join(settings.presentation_directory, css_file)
          end
          css_content += File.read(css_file)
        end
        css_content += '</style>'
        css_content
      end

      def inline_js(jses, pre = nil)
        js_content = '<script type="text/javascript">'
        jses.each do |js_file|
          if pre
            js_file = File.join(File.dirname(__FILE__), '..', pre, js_file)
          else
            js_file = File.join(settings.presentation_directory, js_file)
          end
          js_content += File.read(js_file)
        end
        js_content += '</script>'
        js_content
      end

      def inline_all_js(jses_directory)
         inline_js(Dir.entries(File.join(File.dirname(__FILE__), '..', jses_directory)).find_all{|filename| filename.length > 2 }, jses_directory)
      end

      def index(static=false)
        if static
          @state = presentation.title
          @slides = presentation.to_html
          @asset_path = "./"
        end
        erb :index
      end

      def presenter
        erb :presenter
      end

      def clean_link(href)
        if href && href[0, 1] == '/'
          href = href[1, href.size]
        end
        href
      end

      def slides(static=false)
        presentation.to_html
      end

      def onepage(static=false)
        @slides = presentation.to_html
        erb :onepage
      end

      def pdf(static=true)
        @slides = presentation.to_html
        @no_js = false
        html = erb :onepage
        # TODO make a random filename

        # PDFKit.new takes the HTML and any options for wkhtmltopdf
        # run `wkhtmltopdf --extended-help` for a full list of options
        kit = PDFKit.new(html, ::ShowOffUtils.showoff_pdf_options(settings.presentation_directory))

        # Save the PDF to a file
        file = kit.to_file('/tmp/preso.pdf')
      end

    end


     def self.do_static(what)
        what = "index" if !what

        # Nasty hack to get the actual ShowOff module
        showoff = ShowOff.new
        while !showoff.is_a?(ShowOff)
          showoff = showoff.instance_variable_get(:@app)
        end
        name = showoff.instance_variable_get(:@pres_name)
        path = showoff.instance_variable_get(:@root_path)
        logger = showoff.logger
        data = showoff.send(what, true)
        if data.is_a?(File)
          FileUtils.cp(data.path, "#{name}.pdf")
        else
          out = File.expand_path("#{path}/static")
          # First make a directory
          FileUtils.makedirs(out)
          # Then write the html
          file = File.new("#{out}/index.html", "w")
          file.puts(data)
          file.close
          # Now copy all the js and css
          my_path = File.join( File.dirname(__FILE__), '..', 'public')
          ["js", "css"].each { |dir|
            FileUtils.copy_entry("#{my_path}/#{dir}", "#{out}/#{dir}")
          }
          # And copy the directory
          Dir.glob("#{my_path}/#{name}/*").each { |subpath|
            base = File.basename(subpath)
            next if "static" == base
            next unless File.directory?(subpath) || base.match(/\.(css|js)$/)
            FileUtils.copy_entry(subpath, "#{out}/#{base}")
          }

          # Set up file dir
          file_dir = File.join(out, 'file')
          FileUtils.makedirs(file_dir)
          pres_dir = showoff.settings.presentation_directory

          # ..., copy all user-defined styles and javascript files
          Dir.glob("#{pres_dir}/*.{css,js}").each { |path|
            FileUtils.copy(path, File.join(file_dir, File.basename(path)))
          }

          # ... and copy all needed image files
          data.scan(/img src=\".\/file\/(.*?)\"/).flatten.each do |path|
            dir = File.dirname(path)
            FileUtils.makedirs(File.join(file_dir, dir))
            FileUtils.copy(File.join(pres_dir, path), File.join(file_dir, path))
          end
          # copy images from css too
          Dir.glob("#{pres_dir}/*.css").each do |css_path|
            File.open(css_path) do |file|
              data = file.read
              data.scan(/url\((.*)\)/).flatten.each do |path|
                logger.debug path
                dir = File.dirname(path)
                FileUtils.makedirs(File.join(file_dir, dir))
                FileUtils.copy(File.join(pres_dir, path), File.join(file_dir, path))
              end
            end
          end
        end
      end

    def eval_ruby(code)
     eval(code).to_s
    rescue => e
     e.message
    end

    get '/eval_ruby' do
      if ENV['SHOWOFF_EVAL_RUBY']
        eval_ruby(params[:code])
      else
        "Ruby Evaluation is off. To turn it on set ENV['SHOWOFF_EVAL_RUBY']"
      end
    end
    get %r{(?:image|file)/(.*)} do
      path = params[:captures].first
      full_path = File.join(settings.presentation_directory, path)
      send_file full_path
    end

    get %r{/(.*)} do
      @title = presentation.title
      what = params[:captures].first
      what = 'index' if "" == what
      @asset_path = (env['SCRIPT_NAME'] || '').gsub(/\/?$/, '/').gsub(/^\//, '')
      if (what != "favicon.ico")
        data = send(what)
        if data.is_a?(File)
          send_file data.path
        else
          data
        end
      end
    end
  end

end
