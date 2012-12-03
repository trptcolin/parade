require_relative 'spec_helper'

describe Parade::Metadata::Template do
  
  describe "#match?" do
    it "should match `template=templatename`" do
      subject.match?("template=templatename").should be_true
    end
    
    it "should match `tpl=templatename`" do
      subject.match?("tpl=templatename").should be_true
    end
    
    it "should not match `term`" do
      subject.match?("template").should be_false
    end
  end
  
  describe "#apply" do
    
    let(:term) { "template=templatename" }
    let(:expected_hash) { { :template => "templatename" } }
    
    it "should assign value to the template key into the hash" do
      hash = {}
      subject.apply(term,hash)
      hash.should eq expected_hash
    end
  end
  
end
