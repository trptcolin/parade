require_relative 'spec_helper'

describe ShowOff::Slide do

  context "when initialized with content and metadata" do
    subject { described_class.new :content => content, :metadata => 'one two three' }

    let(:content) { "content" }

    its(:content) { should eq "#{content}\n" }
    its(:metadata) { should be_instance_of ShowOff::Helpers::Metadata }
  end

  describe "#sequence" do
    before do
      subject.sequence = expected_sequence
    end

    let(:expected_sequence) { 1 }
    its(:sequence) { should eq expected_sequence }
    its(:reference) { should eq "slide/#{expected_sequence}" }
  end

  describe "#<<" do

    let(:content) { "new slide content" }

    context "when there is no content" do

      let(:expected_content) { "#{content}\n" }

      it "should append content correctly" do
        subject << content
        subject.content.should eq expected_content
      end
    end

    context "when there is content" do

      subject { described_class.new :content => existing_content }

      let(:existing_content) { "existing content" }

      let(:expected_content) { "#{existing_content}\n#{content}\n" }

      it "should append content correctly" do
        subject << content
        subject.content.should eq expected_content
      end

    end
  end

  describe "#empty?" do
    context "when there is no content" do
      its(:empty?) { should be_true }
    end

    context "when there is content" do
      subject { described_class.new :content => 'new content' }
      its(:empty?) { should be_false }
    end
  end

  describe "#content_classes" do
    context "when created with no metadata" do
      its(:content_classes) { should eq "" }
    end

    context "when created with metadata" do
      context "when created with only classes" do
        subject { described_class.new :metadata => "one two three" }
        its(:content_classes) { should eq "one two three" }
      end

      context "when created with other non-classes metadata" do
        subject { described_class.new :metadata => "#id one two three transition=fade" }
        its(:content_classes) { should eq "one two three" }
      end
    end
  end

  describe "#transition" do
    context "when created with no metadata" do
      let(:default_transition) { "none" }
      its(:transition) { should eq default_transition }
    end

    context "when created with transition metadata" do
      subject { described_class.new :metadata => '#id one two transition=slide three' }
      let(:expected_transition) { 'slide' }

      its(:transition) { should eq expected_transition }
    end
  end

  describe "#id" do
    context "when created with no id in the metadata" do
      subject { described_class.new :metadata => 'one two three' }
      its(:id) { should eq "" }
    end
    context "when created with an id in the metadata" do
      subject { described_class.new :metadata => '#slide_id' }
      its(:id) { should eq "slide_id" }
    end
  end

  describe "#content_as_html" do

    subject { described_class.new :content => content }

    let(:content) { 'content' }
    let(:renderer) { mock('Markdown Renderer', :render => expected_html_content) }
    let(:expected_html_content) { 'content as html' }

    it "should attempt to render the markdown content" do
      Redcarpet::Markdown.stub(:new).and_return(renderer)
      subject.content_as_html.should eq expected_html_content
    end
  end

  its(:template_file) { should be_instance_of ERB }

  describe "#to_html" do
    let(:template) { mock('mock ERB template', :result => expected_html) }
    let(:expected_html) { 'expected html' }

    it "should render the template file" do
      subject.stub(:template_file).and_return(template)
      subject.to_html.should eq expected_html
    end
  end

end
