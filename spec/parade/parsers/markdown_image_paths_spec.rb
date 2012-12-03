require_relative 'spec_helper'

describe Parade::Parsers::MarkdownImagePaths do

  subject { Parade::Parsers::MarkdownImagePaths }

  describe "::parse" do

    context "when given markdown content with no image" do
      let(:content) { NO_IMAGE_PATH }
      let(:expected_content) { EXPECTED_NO_IMAGE_PATH }

      it "should return the same markdown content" do
        subject.parse(content).should eq expected_content
      end
    end

    context "when given markdown content with images" do

      context "when not given a path value" do
        let(:content) { IMAGE_PATH_START }
        let(:expected_content) { IMAGE_PATH_START }

        it "should return the same markdown content" do
          subject.parse(content).should eq expected_content
        end
      end

      context "when an image is at the beginning of a line" do
        let(:content) { IMAGE_PATH_START }
        let(:expected_content) { EXPECTED_IMAGE_PATH_START }

        it "should update path of the image" do
          subject.parse(content, :path => 'section').should eq expected_content
        end
      end

      context "when an image is at the end of a line" do
        let(:content) { IMAGE_PATH_END }
        let(:expected_content) { EXPECTED_IMAGE_PATH_END }

        it "should update path of the image" do
          subject.parse(content, :path => 'section').should eq expected_content
        end
      end

      context "when an image is in the middle of a line" do
        let(:content) { IMAGE_PATH_MIDDLE }
        let(:expected_content) { EXPECTED_IMAGE_PATH_MIDDLE }

        it "should update path of the image" do
          subject.parse(content, :path => 'section').should eq expected_content
        end
      end

      context "when an image is an external source" do

        let(:content) { IMAGE_WITH_EXTERNAL_SRC }
        let(:expected_content) { EXPECTED_IMAGE_WITH_EXTERNAL_SRC }

        it "should not update the path of the image" do
          subject.parse(content, :path => 'section').should eq expected_content
        end

      end

    end
  end

end
