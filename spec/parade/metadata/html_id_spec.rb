require_relative 'spec_helper'

describe Parade::Metadata::HTMLId do
  
  describe "#match?" do
    it "should match the term `#htmlid`" do
      subject.match?("#htmlid").should be_true
    end
    
    it "should not match `term`" do
      subject.match?("htmlid").should be_false      
    end
  end
  
  describe "#apply" do
    let(:term) { "#htmlid" }
    let(:expected_hash) { { :id => "htmlid" } }
    
    it "should assign value to the id key into the hash" do
      hash = {}
      subject.apply(term,hash)
      hash.should eq expected_hash
    end
  end
  
end
