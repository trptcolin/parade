require_relative 'spec_helper'

describe "Loading the Example Presentation", :integration => true do

  subject do
    ShowOff::Parsers::PresentationDirectoryParser.parse "example",
      :root_path => "example", :showoff_file => "showoff"
  end

  let(:default_title) { "Example Presentation" }
  let(:description) { "Several showoff examples to assist with showing others how to get started with ShowOff" }
  let(:slide_count) { 76 }
  let(:section_count) { 3 }

  its(:title) { should eq default_title }
  its(:description) { should eq description }


  it "should have 5 sub-sections" do
    subject.sections.count.should eq section_count
  end

  it "should have the expected number of slides" do
    subject.slides.count.should eq slide_count
  end

  describe "Introduction" do
    let(:section) { subject.sections.first }

    let(:title) { "Introduction" }
    let(:slide_count) { 11 }

    it_should_behave_like "a properly parsed section"
  end

  describe "Advanced Features" do
    let(:section) { subject.sections[1] }

    let(:title) { "Advanced Features" }
    let(:slide_count) { 54 }

    it_should_behave_like "a properly parsed section"
  end

  describe "Code Samples" do
    let(:section) { subject.sections[2] }

    let(:title) { "Code Samples" }
    let(:slide_count) { 11 }

    it_should_behave_like "a properly parsed section"
  end

end