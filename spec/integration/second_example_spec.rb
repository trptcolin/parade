require_relative 'spec_helper'

describe "Loading the Example Presentation", :integration => true do

  subject do
    ShowOff::Parsers::PresentationDirectoryParser.parse "example",
      :root_path => "example", :showoff_file => "showoff.rb"
  end

  let(:slide_count) { 15 }
  let(:section_count) { 2 }
  let(:default_title) { "Section" }
  
  it "should have 3 sub-sections" do
    subject.sections.count.should eq section_count
  end

  it "should have the expected number of slides" do
    subject.slides.count.should eq slide_count
  end

  describe "First Section" do
    let(:section) { subject.sections[0] }

    let(:title) { default_title }
    let(:slide_count) { 8 }

    it_should_behave_like "a properly parsed section"
  end

  describe "Second Section" do
    let(:section) { subject.sections[1] }

    let(:title) { default_title }
    let(:slide_count) { 7 }

    it_should_behave_like "a properly parsed section"
  end

end