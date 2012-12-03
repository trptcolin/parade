require_relative 'spec_helper'

describe Parade::Parsers::MarkdownSlideSplitter do

  subject { Parade::Parsers::MarkdownSlideSplitter.parse content }

  context "when the markdown file contains one slide" do
    let(:content) { ONE_SLIDE }

    it "should parse the correct number of slides" do
      subject.count.should eq 1
    end
  end

  context "when the markdown file contains multiple slides" do
    let(:content) { MULTIPLE_SLIDES }

    it "should parse the correct number of slides" do
      subject.count.should eq 3
    end
  end

  context "when the markdown file contains no slide markers" do
    let(:content) { SLIDES_WITH_H1 }

    it "should parse the correct number of slides from the `#` tags" do
      subject.count.should eq 2
    end
  end

end
