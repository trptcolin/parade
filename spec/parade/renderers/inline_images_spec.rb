require_relative 'spec_helper'

describe Parade::Renderers::InlineImages do
  before do
    subject.stub(:image_path_to_base64).and_return("IMG_DATA_64_BITS")
  end

  subject { described_class }

  let(:expected_content) { EXPECTED_IMG_INLINED_DATA }

  describe "#render" do
    context "when given a single quoted img src" do
      let(:content) { IMG_WITH_SINGLE_QUOTES }

      it "should render the image data correctly inline" do
        subject.render(content).should eq expected_content
      end
    end

    context "when given a double quoted img src" do
      let(:content) { IMG_WITH_SRC }

      it "should render the image data correctly inline" do
        subject.render(content).should eq expected_content
      end
    end
  end



end