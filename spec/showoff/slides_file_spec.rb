require_relative 'spec_helper'

describe ShowOff::SlidesFile do

  subject { described_class.new :filepath => filepath, :section => section }

  let(:filepath) { 'filepath/slides.md' }
  let(:section) { mock('Section', :presentation => mock(:rootpath => 'presentation')) }

  its(:filepath) { should eq filepath }
  its(:section) { should eq section }

  let(:expected_rootpath) { File.dirname filepath }

  its(:rootpath) { should eq expected_rootpath }

  describe "#to_slides" do
    before do
      subject.stub(:markdown_content).and_return(markdown_content)
      ShowOff::Parsers::MarkdownImagePaths.stub(:parse).and_return(markdown_content)
      ShowOff::Parsers::MarkdownSlideSplitter.stub(:parse).and_return([])
    end

    let(:markdown_content) { 'markdown content' }

    it "should return an array of Slides" do
      subject.to_slides.should be_kind_of Enumerable
    end

  end
end
