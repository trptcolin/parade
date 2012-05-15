require_relative 'spec_helper'

describe ShowOff::Renderers::UpdateImagePaths do

  let(:content) { IMG_WITH_SRC }

  context "when given html content with images" do
    before do
      subject.stub(:get_image_size).and_return([nil, nil])
    end
    
    let(:expected_content) { EXPECTED_IMG_WITH_SRC }

    it "should update the img src paths correctly" do
      subject.render(content).should eq expected_content
    end
  end

  context "when Magick has been installed" do
    context "when given html content with images" do
      context "when the image size returns a height and width" do
        before do
          subject.should_receive(:get_image_size).with("/home/application/path/to/some/image.png").and_return([101,99])
        end

        let(:expected_content) { EXPECTED_IMG_WITH_W_AND_H }

        it "should update the img src paths correctly" do
          subject.render(content, :rootpath => "/home/application/").should eq expected_content
        end
      end
    end
  end

end
