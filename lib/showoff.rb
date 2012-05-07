require 'rubygems'
require 'sinatra/base'
require 'json'
require 'nokogiri'
require 'fileutils'
require 'logger'
require 'tilt'

begin
  require 'RMagick'
rescue LoadError
  $stderr.puts 'image sizing disabled - install rmagick'
end

begin
  require 'pdfkit'
rescue LoadError
  $stderr.puts 'pdf generation disabled - install pdfkit'
end

require_relative "commandline_parser"
require_relative "presentation"

class ShowOff < Sinatra::Application

  attr_reader :cached_image_size

  set :views, File.dirname(__FILE__) + '/../views'
  set :public_folder, File.dirname(__FILE__) + '/../public'

  set :verbose, false
  set :pres_dir, '.'
  set :pres_file, 'showoff.json'

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
    Presentation.new :outline_filepath => File.join(settings.pres_dir,settings.pres_file)
  end

  def initialize(app=nil)
    super(app)

    root_directory = File.expand_path(File.join(File.dirname(__FILE__), '..'))

    settings.pres_dir ||= Dir.pwd
    @root_path = "."

    settings.pres_dir = File.expand_path(settings.pres_dir)

    # if (settings.pres_file)
    #   ShowOffUtils.presentation_config_file = settings.pres_file
    # end

    @cached_image_size = {}

    @pres_name = settings.pres_dir.split('/').pop

    require_ruby_files

    # Default asset path
    @asset_path = "./"
  end

  def self.pres_dir_current
    opt = {:pres_dir => Dir.pwd}
    ShowOff.set opt
  end

  def require_ruby_files
    Dir.glob("#{settings.pres_dir}/*.rb").map { |path| require path }
  end

  helpers do
    def css_files
      Dir.glob("#{settings.pres_dir}/*.css").map { |path| File.basename(path) }
    end

    def js_files
      Dir.glob("#{settings.pres_dir}/*.js").map { |path| File.basename(path) }
    end

    def preshow_files
      Dir.glob("#{settings.pres_dir}/_preshow/*").map { |path| File.basename(path) }.to_json
    end

    def inline_css(csses, pre = nil)
      css_content = '<style type="text/css">'
      csses.each do |css_file|
        if pre
          css_file = File.join(File.dirname(__FILE__), '..', pre, css_file)
        else
          css_file = File.join(settings.pres_dir, css_file)
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
          js_file = File.join(settings.pres_dir, js_file)
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
        @slides = presentation.get_slides_html(static)
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

    def assets_needed
      assets = ["index", "slides"]

      index = erb :index
      html = Nokogiri::XML.parse(index)
      html.css('head link').each do |link|
        href = clean_link(link['href'])
        assets << href if href
      end
      html.css('head script').each do |link|
        href = clean_link(link['src'])
        assets << href if href
      end

      slides = presentation.get_slides_html
      html = Nokogiri::XML.parse("<slides>" + slides + "</slides>")
      html.css('img').each do |link|
        href = clean_link(link['src'])
        assets << href if href
      end

      css = Dir.glob("#{settings.public_folder}/**/*.css").map { |path| path.gsub(settings.public_folder + '/', '') }
      assets << css

      js = Dir.glob("#{settings.public_folder}/**/*.js").map { |path| path.gsub(settings.public_folder + '/', '') }
      assets << js

      assets.uniq.join("\n")
    end

    def slides(static=false)
      presentation.get_slides_html(static)
    end

    def onepage(static=false)
      @slides = presentation.get_slides_html(static)
      erb :onepage
    end

    # def pdf(static=true)
    #   @slides = get_slides_html(static, true)
    #   @no_js = false
    #   html = erb :onepage
    #   # TODO make a random filename
    #
    #   # PDFKit.new takes the HTML and any options for wkhtmltopdf
    #   # run `wkhtmltopdf --extended-help` for a full list of options
    #   kit = PDFKit.new(html, ShowOffUtils.showoff_pdf_options(settings.pres_dir))
    #
    #   # Save the PDF to a file
    #   file = kit.to_file('/tmp/preso.pdf')
    # end

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
        pres_dir = showoff.settings.pres_dir

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

   def eval_ruby code
     eval(code).to_s
   rescue => e
     e.message
   end

  get '/eval_ruby' do
    return eval_ruby(params[:code]) if ENV['SHOWOFF_EVAL_RUBY']

    return "Ruby Evaluation is off. To turn it on set ENV['SHOWOFF_EVAL_RUBY']"
  end

  get %r{(?:image|file)/(.*)} do
    path = params[:captures].first
    full_path = File.join(settings.pres_dir, path)
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
