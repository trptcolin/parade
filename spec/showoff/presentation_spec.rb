require_relative 'spec_helper'

describe ShowOff::Presentation do
  subject { described_class.new :filepath => filepath }

  context "when created with a presentation file" do
    before do
      File.stub(:directory?).with(filepath).and_return(false)
      File.stub(:exists?).with(filepath).and_return(true)
    end

    let(:filepath) { 'path/to/showoff.json' }

    let(:expected_rootpath) { File.dirname filepath }
    its(:rootpath) { should eq expected_rootpath  }

    describe "#contents" do

    end

  end

  context "when created with a directory" do
    before do
      File.stub(:directory?).with(filepath).and_return(true)
    end

    let(:filepath) { 'path' }

    let(:expected_rootpath) { filepath }
    its(:rootpath) { should eq expected_rootpath  }

  end

end
