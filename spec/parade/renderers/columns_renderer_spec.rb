require_relative 'spec_helper'

describe Parade::Renderers::ColumnsRenderer do
  
  subject { described_class.new :css_class => 'columns',:html_element => "h2",:segments => 12 }
  
  context "when given HTML with two H2 elements" do
    it "should generate the correct column output" do
      
      subject.render(TWO_COLUMN).should eq EXPECTED_TWO_COLUMN
      
    end
  end
  
  
end
