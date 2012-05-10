require 'spec_helper'

module ShowOff

  describe Slide do

    subject do
      Slide.new :metadata => "bullets incremental #first transition=fade", :content => '# My Slide'
    end

    its(:id) { should eq "first" }
    its(:classes) { should eq "bullets incremental" }
    its(:transition) { should eq "fade" }
    its(:empty?) { should be_false }

    describe "#to_html" do
      it "should not blow up" do
        subject.to_html.should_not eq ""
      end
    end
  end

end