require_relative 'spec_helper'

describe ShowOff::Parsers::DSL do

  subject { described_class }

  let(:contents) { SHOWOFF_TITLE_AND_SECTIONS }

  describe "#parse" do
    it "should parse the contents without error" do
      expect { subject.parse(contents) }.to_not raise_error
    end

    describe "the presentation parsed" do
      before do
        ShowOff::Parsers::PresentationFilepathParser.stub(:parse) { SLIDES_WITH_H1 }
      end

      let(:presentation) { subject.parse(contents) }
      let(:expected_title) { "My Presentation" }
      let(:expected_section_count) { 3 }

      it "should have the correct title" do
        presentation.title.should eq expected_title
      end

      it "should have the defined sections" do
        presentation.sections.count.should eq expected_section_count
      end
    end
    it "should return a presentation" do

    end
  end

end
