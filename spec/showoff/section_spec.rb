require_relative 'spec_helper'

describe ShowOff::Section do

  subject do
    described_class.new :title => expected_title
  end

  let(:expected_title) { "Section Title" }

  its(:title) { should eq expected_title }
  its(:sections) { should be_empty }

  describe "#add_section" do
    before do
      slide.stub(:to_a) { [ slide ] }
      slide.stub(:section=)
      section.stub(:to_a) { [ section ] }
      section.stub(:section=)
    end

    let(:slide) { mock('Slide') }
    let(:section) { mock('Section') }
    let(:slides_and_sections) { [ slide, section ] }

    context "when given a slide" do
      it "should be appended to the sections" do
        subject.add_section(slide)
        subject.sections.should eq [ slide ]
      end
    end
    context "when give a section" do
      it "should be appended to the sections" do
        subject.add_section(section)
        subject.sections.should eq [ section ]
      end
    end
    context "when given an array of slides and sections" do
      it "should be appended to the sections" do
        subject.add_section(slides_and_sections)
        subject.sections.should eq slides_and_sections
      end
    end
  end

end
