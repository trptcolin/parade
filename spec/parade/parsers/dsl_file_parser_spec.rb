require_relative 'spec_helper'

describe Parade::Parsers::DslFileParser do

  subject { described_class }

  let(:expected_options) do
    { }
  end

  let(:file_contents) { mock('dsl file contents') }

  let(:filepath) { "parade" }

  it "should parse the file contents with the DSL" do
    File.stub(:read).with(filepath).and_return(file_contents)
    Parade::Parsers::Dsl.should_receive(:parse).with(file_contents,expected_options)
    subject.parse(filepath,expected_options)
  end

end
