require_relative 'spec_helper'

describe ShowOff::Section do

  let(:filepath) { "path/filepath" }
  let(:presentation) { mock('Presentation') }

  subject { described_class.new :presentation => presentation }

  its(:presentation) { should eq presentation }

  describe "#sections" do
    context "when given a sections with file sections" do

      let(:sections) do
        [ {'section' => 'slidesA.md'},{'section' => 'slidesB.md'} ]
      end

      it "should create slides files for each section" do
        ShowOff::SlidesFile.should_receive(:new).with(:filepath => 'slidesA.md', :section => subject)
        ShowOff::SlidesFile.should_receive(:new).with(:filepath => 'slidesB.md', :section => subject)
        subject.sections = sections
      end

    end
    context "when given sections with sub-sections" do

      let(:sections) do
        [ {'section' => {'sections' => subsection} } ]
      end

      let(:subsection) do
        [ {'section' => 'slidesA.md'},{'section' => 'slidesB.md'} ]
      end

      let(:expected_data_for_subsection) do
        sections.first['section'].merge(:presentation => presentation)
      end

      it "should create slides files for each section" do
        subject.should_receive(:create_subsection).with(expected_data_for_subsection)
        subject.sections = sections
      end

    end
  end

  describe "#to_html" do
    before do
      subject.stub(:slides).and_return(slides)
      subject.stub(:renderers).and_return([])
    end
    
    let(:slides) do
      [ mock('Slide',:to_html => 'slide A html'), mock('Slide2',:to_html => 'slide B html')]
    end

    let(:expected_html) { "slide A html\nslide B html" }

    its(:to_html) { should eq expected_html }

  end
end
