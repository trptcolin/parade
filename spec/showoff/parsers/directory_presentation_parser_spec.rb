require_relative 'spec_helper'

module ShowOff::Parsers

  describe DirectoryPresentationParser do
    describe "::parse" do

      let(:filepath) { "path/of/directory" }

      context "when the directory contains the default presentation file" do
        before do
          File.stub(:exists?).with(File.join(filepath,'showoff.json')).and_return(true)
        end

        it "should process the presentation file" do
          FilePresentationParser.should_receive(:parse)
          DirectoryPresentationParser.parse(filepath)
        end
      end

      context "when the directory contains several markdown files" do
        before do
          Dir.stub(:[]).with(File.join(filepath,"**","*.md")).and_return([ '1.md', '2.md' ])
        end

        let(:expected_config) do
          { :sections => [ {:section => '1.md'}, {:section => '2.md'} ], :filepath => filepath }
        end

        it "should create a presentation with markdown files it has found" do
          ShowOff::Outline.should_receive(:new).with(expected_config)
          DirectoryPresentationParser.parse(filepath)
        end
      end

    end
  end

end