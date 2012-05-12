require_relative 'spec_helper'

describe ShowOff::Renderers::UpdateImagePaths do

  subject { ShowOff::Renderers::UpdateImagePaths }

  context "when given html content with images" do
    let(:content) { IMG_WITH_SRC }
    let(:expected_content) { EXPECTED_IMG_WITH_SRC }

    it "should update the img src paths correctly" do
      subject.render(content).should eq expected_content
    end
  end

end
