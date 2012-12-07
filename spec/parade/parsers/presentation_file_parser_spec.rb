require_relative 'spec_helper'

describe Parade::Parsers::PresentationFileParser do

  subject { described_class }

  context "when the file extension is json" do

    let(:filepath) { "current/path/parade.json" }

    let(:expected_options) do
      { :current_path => File.dirname(filepath) }
    end

    it "should use the JSON Parser" do
      Parade::Parsers::JsonFileParser.should_receive(:parse).with(filepath,expected_options)
      subject.parse(filepath)
    end
    
  end

  context "when the file extension is not json" do

    let(:filepath) { "parade" }

    let(:expected_options) do
      { :current_path => File.dirname(filepath) }
    end

    it "should use the DSL Paser" do
      Parade::Parsers::DslFileParser.should_receive(:parse).with(filepath,expected_options)
      subject.parse(filepath)
    end
  end

end
