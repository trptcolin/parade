require_relative "renderers/html_with_pygments"
require_relative "markdown_processor"

class Presentation

  attr_accessor :filepath

  def initialize(params = {})
    params.each {|k,v| send("#{k}=",v) if respond_to? "#{k}=" }
  end

  def rootpath
    File.directory?(filepath) ? filepath : File.dirname(filepath)
  end

  def contents
    if File.exists? filepath
      file_data = File.read(filepath)
      JSON.parse(file_data)
    else
      { 'name' => 'Presentation', 'sections' => ['.'] }
    end

    # TODO: there are defaults that need to be merged here as well
  end

  def directory
    File.expand_path(File.dirname(filepath) || ".")
  end

  #
  #
  #
  def title
    contents['name'] || "Presentation"
  end

  def section_files
    pathpath = contents['section'] || "**/*.md"
    Dir[File.join(directory,pathpath)]
  end

  def sections
    section_files.map do |filepath|
      Section.new :filepath => filepath, :presentation => self
    end
  end

  #
  #
  #
  def to_slides_html(static = nil,pdf = nil)
    sections.map {|section| section.slides.map {|slide| slide.to_html}}.flatten.join("\n")
  end

  class Section

    attr_accessor :filepath
    attr_accessor :presentation

    def rootpath
      File.directory?(filepath) ? filepath : File.dirname(filepath)
    end

    def initialize(params = {})
      params.each {|k,v| send("#{k}=",v) if respond_to? "#{k}=" }
    end

    def files
      filepaths = File.directory?(filepath) ? File.join(filepath,"**","*.md") : filepath
      Dir[filepaths]
    end

    def slides
      files.map {|file| SlidesFile.new :filepath => file, :section => self }
    end

  end

  class SlidesFile

    attr_accessor :filepath
    attr_accessor :section

    def initialize(params = {})
      @cached_image_size = {}
      params.each {|k,v| send("#{k}=",v) if respond_to? "#{k}=" }
    end

    def rootpath
      File.directory?(filepath) ? filepath : File.dirname(filepath)
    end

    def content
      File.read(filepath)
    end

    def to_html
      process_markdown("name",content,nil,nil)
    end

    def debug(message)
      puts "DEBUG: #{message}"
    end

    def process_markdown(name, content, static=false, pdf=false)

      # if there are no !SLIDE markers, then make every H1 define a new slide
      unless content =~ /^\<?!SLIDE/m
        content = content.gsub(/^# /m, "<!SLIDE>\n# ")
      end

      # todo: unit test
      lines = content.split("\n")
      debug "#{name}: #{lines.length} lines"
      slides = []
      slides << (slide = Slide.new)
      until lines.empty?
        line = lines.shift
        if line =~ /^<?!SLIDE(.*)>?/
          slides << (slide = Slide.new($1))
        else
          slide << line
        end
      end

      slides.delete_if {|slide| slide.empty? }

      final = ''
      if slides.size > 1
        seq = 1
      end
      slides.each do |slide|
        md = ''
        content_classes = slide.classes

        # extract transition, defaulting to none
        transition = 'none'
        content_classes.delete_if { |x| x =~ /^transition=(.+)/ && transition = $1 }
        # extract id, defaulting to none
        id = nil
        content_classes.delete_if { |x| x =~ /^#([\w-]+)/ && id = $1 }
        debug "id: #{id}" if id
        debug "classes: #{content_classes.inspect}"
        debug "transition: #{transition}"
        # create html
        md += "<div"
        md += " id=\"#{id}\"" if id
        md += " class=\"slide\" data-transition=\"#{transition}\">"
        if seq
          md += "<div class=\"#{content_classes.join(' ')}\" ref=\"#{name}/#{seq.to_s}\">\n"
          seq += 1
        else
          md += "<div class=\"#{content_classes.join(' ')}\" ref=\"#{name}\">\n"
        end

        sl = from_markdown(slide.text)

        sl = update_image_paths(name, sl, static, pdf)
        md += sl
        md += "</div>\n"
        md += "</div>\n"
        final += update_commandline_code(md)
        final = update_p_classes(final)
      end
      final
    end

    def update_commandline_code(slide)
      html = Nokogiri::XML.parse(slide)
      parser = CommandlineParser.new

      html.css('pre').each do |pre|
        pre.css('code').each do |code|
          out = code.text
          lines = out.split("\n")
          if lines.first.strip[0, 3] == '@@@'
            lang = lines.shift.gsub('@@@', '').strip
            pre.set_attribute('class', 'sh_' + lang.downcase)
            code.content = lines.join("\n")
          end
        end
      end

      html.css('.commandline > pre > code').each do |code|
        out = code.text
        code.content = ''
        tree = parser.parse(out)
        transform = Parslet::Transform.new do
          rule(:prompt => simple(:prompt), :input => simple(:input), :output => simple(:output)) do
            command = Nokogiri::XML::Node.new('code', html)
            command.set_attribute('class', 'command')
            command.content = "#{prompt} #{input}"
            code << command

            # Add newline after the input so that users can
            # advance faster than the typewriter effect
            # and still keep inputs on separate lines.
            code << "\n"

            unless output.to_s.empty?

              result = Nokogiri::XML::Node.new('code', html)
              result.set_attribute('class', 'result')
              result.content = output
              code << result
            end
          end
        end
        transform.apply(tree)
      end
      html.root.to_s
    end

    # find any lines that start with a <p>.(something) and turn them into <p class="something">
    def update_p_classes(markdown)
      markdown.gsub(/<p>\.(.*?) /, '<p class="\1">')
    end

    def html_asset_path
      @html_asset_path ||= begin
        rootpath.gsub(section.presentation.rootpath,'image')
      end
    end

    def image_asset_path(source_path)
      File.join(rootpath,source_path)
    end

    def update_image_paths(path, slide, static=false, pdf=false)
      html_asset_path

      slide.gsub(/img src=\"([^\/].*?)\"/) do |image_source|
        html_image_path = File.join(html_asset_path,$1)
        src      = "img src=\"#{html_image_path}\""

        w, h     = get_image_size(image_asset_path($1))
        src << %( width="#{w}" height="#{h}") if w and h

        src
      end
    end

    def from_markdown(text)
      # options = [:fenced_code => true, :generate_toc => true, :hard_wrap => true, :no_intraemphasis => true, :strikethrough => true ,:gh_blockcode => true, :autolink => true, :xhtml => true, :tables => true]
      markdown = Redcarpet::Markdown.new(HTMLwithPygments,
        :fenced_code_blocks => true,
        :no_intra_emphasis => true,
        :autolink => true,
        :strikethrough => true,
        :lax_html_blocks => true,
        :superscript => true,
        :hard_wrap => true,
        :tables => true,
        :xhtml => true)
      markdown.render(text)
    end

    attr_accessor :cached_image_size

    if defined?(Magick)

      def get_image_size(path)
        unless cached_image_size.key?(path)
          # @asset_path
          # image_path = File.join(File.dirname(filepath),path)
          image = Magick::Image.ping(path).first
          # don't set a size for svgs so they can expand to fit their container
          if image.mime_type == 'image/svg+xml'
            cached_image_size[path] = [nil, nil]
          else
            cached_image_size[path] = [image.columns, image.rows]
          end
        end
        cached_image_size[path]
      end

    else

      def get_image_size(path)
      end
    end

  end

  class Slide
    attr_reader :classes, :text
    def initialize classes = ""
      @classes = ["content"] + classes.strip.chomp('>').split
      @text = ""
    end
    def <<(s)
      @text << s
      @text << "\n"
    end
    def empty?
      @text.strip == ""
    end
  end
end
