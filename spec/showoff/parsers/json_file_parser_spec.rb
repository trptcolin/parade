require_relative 'spec_helper'

describe ShowOff::Parsers::JsonFileParser do

  subject { described_class }


  describe ".parse" do

    let(:filepath) { "showoff.json" }

    let(:file_contents) { mock('showoff json contents') }

    let(:dsl_contents) { mock("dsl contents") }

    let(:expected_options) do
      {}
    end


    it "should load the file, convert it to the DSL format, and parse it" do
      File.stub(:read).with(filepath).and_return(file_contents)
      JSON.should_receive(:parse).with(file_contents).and_return(file_contents)

      described_class.should_receive(:convert_to_showoff_dsl).with(file_contents).and_return(dsl_contents)
      ShowOff::Parsers::Dsl.should_receive(:parse).with(dsl_contents,expected_options)

      described_class.parse(filepath)
    end

  end


  describe ".convert_to_showoff_dsl" do

    context "when given a hash of sub-sections" do

      let(:contents) do
        { 'sections' => [ { 'section' => 'one' }, { 'section' => 'two' } ] }
      end

      let(:expected) { "slides 'one'\nslides 'two'\n" }

      it "should generate the correct data for the DSL to parse" do
        described_class.convert_to_showoff_dsl(contents).should eq expected
      end

      context "when given a list of sections" do

        let(:contents) do
          { 'sections' => [ 'one', 'two' ] }
        end

        let(:expected) { "slides 'one'\nslides 'two'\n" }

        it "should generate the correct data for the DSL to parse" do
          described_class.convert_to_showoff_dsl(contents).should eq expected
        end

      end

      context "when given a single section" do

        let(:contents) do
          { 'sections' => 'one' }
        end

        let(:expected) { "slides 'one'\n" }

        it "should generate the correct data for the DSL to parse" do
          described_class.convert_to_showoff_dsl(contents).should eq expected
        end

      end

    end

  end



end
