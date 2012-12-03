require_relative 'spec_helper'

describe Parade::Parsers::SlidesFileContentParser do

  subject { described_class }

  before do
    File.stub(:read).with(filepath).and_return(slides_content)
  end

  let(:filepath) { "example/intro.md" }

  let(:slides_content) { mock('slides content') }

  context "when given a root path 'example/'" do

    let(:options) do
      { :root_path => 'example/' }
    end

    it "should update markdown image paths with path ''" do
      Parade::Parsers::MarkdownImagePaths.should_receive(:parse).with(slides_content,:path => '')
      described_class.stub(:create_section_with)
      subject.parse(filepath,options)
    end
  end

  context "when given a root path 'example'" do

    let(:options) do
      { :root_path => 'example' }
    end

    it "should update markdown image paths with path '' " do
      Parade::Parsers::MarkdownImagePaths.should_receive(:parse).with(slides_content,:path => '')
      described_class.stub(:create_section_with)
      subject.parse(filepath,options)
    end

  end


end
