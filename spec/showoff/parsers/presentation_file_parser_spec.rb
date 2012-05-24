require_relative 'spec_helper'

describe ShowOff::Parsers::PresentationFileParser do

  subject { described_class }

  context "when the file extension is json" do

    let(:filepath) { "current/path/showoff.json" }

    let(:expected_options) do
      { :current_path => File.dirname(filepath) }
    end

    it "should use the JSON Parser" do
      ShowOff::Parsers::JsonFileParser.should_receive(:parse).with(filepath,expected_options)
      subject.parse(filepath)
    end
    
  end

  context "when the file extension is not json" do

    let(:filepath) { "showoff" }

    let(:expected_options) do
      { :current_path => File.dirname(filepath) }
    end

    it "should use the DSL Paser" do
      ShowOff::Parsers::DslFileParser.should_receive(:parse).with(filepath,expected_options)
      subject.parse(filepath)
    end
  end

end
