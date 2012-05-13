require_relative 'spec_helper'

describe ShowOff::Section do

  let(:filepath) { "path/filepath" }
  let(:presentation) { mock('Presentation') }

  subject { ShowOff::Section.new :filepath => filepath, :presentation => presentation }

  context "when initialized with a filepath and project" do
    its(:filepath) { should eq filepath }
    its(:presentation) { should eq presentation }
  end

  context "when given a directory" do
    before do
      File.stub(:directory?).and_return(true)
    end

    let(:expected_rootpath) { filepath }
    its(:rootpath) { should eq expected_rootpath }


    let(:expected_markdownpath) { File.join(filepath,'**','*.md') }
    let(:expected_files) { ['a.md'] }

    it "should return all the markdown files in all sub-directories" do
      Dir.should_receive(:[]).with(expected_markdownpath).and_return(expected_files)
      subject.files.should eq expected_files
    end

  end


  context "when given a file" do
    before do
      File.stub(:directory?).and_return(false)
    end

    let(:expected_rootpath) { File.dirname(filepath) }

    its(:rootpath) { should eq expected_rootpath }

    let(:expected_markdownpath) { filepath }
    let(:expected_files) { ['a.md'] }

    it "should return the file specified" do
      Dir.should_receive(:[]).with(expected_markdownpath).and_return(expected_files)
      subject.files.should eq expected_files
    end

  end

end
