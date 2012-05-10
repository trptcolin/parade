require_relative 'spec_helper'

module ShowOff::Parsers

  describe FilePresentationParser do

    let(:outline) { { 'sections' => 'section_data' } }
    let(:filepath) { "showoff.json" }

    describe "::parse" do
      before do
        File.stub(:read).with(filepath).and_return("json_data")
        JSON.stub(:parse).with("json_data").and_return(outline)
      end

      it "should create a presentation with the config found in the file" do
        ShowOff::Outline.should_receive(:new).with(outline.merge(:filepath => filepath))
        FilePresentationParser.parse filepath
      end
    end
  end

end