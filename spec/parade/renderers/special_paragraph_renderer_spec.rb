require_relative 'spec_helper'

describe Parade::Renderers::SpecialParagraphRenderer do

  subject { Parade::Renderers::SpecialParagraphRenderer }

  context "when given html content with a notes paragraph" do

    let(:content) { PARAGRAPH_NOTES_CLASS }
    let(:expected_content) { EXPECTED_PARAGRAPH_NOTES_CLASS }

    it "should render the content correctly" do
      subject.render(content).should eq expected_content
    end
  end
end
