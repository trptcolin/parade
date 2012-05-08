module ShowOff
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