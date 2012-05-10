require_relative 'spec_helper'

module ShowOff
  describe Outline do

    describe "#title" do
      context "when created with no title" do
        let(:default_title) { Outline::DEFAULT_TITLE }
        its(:title) { should eq default_title }
      end

      context "when created with a title" do
        let(:expected_title) { 'Topics In Algebra' }
        let(:configuration) do
          { 'title' => expected_title }
        end

        subject { described_class.new configuration }

        its(:title) { should eq expected_title }
      end
    end

    describe "#sections" do
      context "when created with sections" do
        context "when the sections are files" do
          let(:configuration) do
            { :sections => [
              { :section => 'A.md' },
              { :section => 'B.md'} ] }
          end

          it "should attempt to load the slides" do
            Section.should_receive(:new).twice
            Outline.new configuration
          end
        end

        context "when the sections are folders" do
          let(:configuration) do
            { :sections => [
              { :section => 'one' },
              { :section => 'two'} ] }
          end

          it "should attempt to load the slides" do
            Section.should_receive(:new).twice
            Outline.new configuration
          end
        end
      end

    end
  end
end
