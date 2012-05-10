require_relative 'spec_helper'

module ShowOff
  describe Presentation do
    describe "::load" do

      let(:outline) { 'outline data' }

      context "when a presentation file has been specified" do
        before do
          File.stub(:exists?).with(filepath).and_return(true)
          File.stub(:directory?).with(filepath).and_return(false)
        end

        let(:filepath) { "presentation.json" }

        it "should create a presentation with the presentation file" do
          Parsers::FilePresentationParser.should_receive(:parse).and_return(outline)
          Presentation.should_receive(:new).with(:outline => outline)
          Presentation.load filepath
        end
      end

      context "when a directory has been specified" do
        before do
          File.stub(:exists?).with(filepath).and_return(true)
          File.stub(:directory?).with(filepath).and_return(true)
        end

        let(:filepath) { "path/of/presentation" }

        it "should create a presentation from the specified directory" do
          Parsers::DirectoryPresentationParser.should_receive(:parse)
          Presentation.load filepath
        end
      end

      context "when the directory or file does not exist" do
        before do
          File.stub(:exists?).with(filepath).and_return(false)
        end

        let(:filepath) { 'missing/path/or/file.json' }

        it "should raise an error" do
          expect { Presentation.load filepath }.to raise_exception
        end
      end

      context "when no path has been specified" do
        before do
          File.stub(:exists?).with(".").and_return(true)
          File.stub(:directory?).with(".").and_return(true)
        end

        let(:filepath) { nil }

        it "should create a presentation from the current directory" do
          Parsers::DirectoryPresentationParser.should_receive(:parse).and_return(outline)
          Presentation.should_receive(:new).with(:outline => outline)
          Presentation.load filepath
        end
      end

    end
  end
end
