require_relative 'spec_helper'

describe Parade::Metadata::Assignment do

  describe "#match?" do

    it "should match a `key=value` term" do
      subject.match?("key=value").should be_true
    end

    it "should not match a `key` term" do
      subject.match?("key").should be_false
    end
  end
  
  describe "#apply" do
    
    let(:term) { "transition=fade" }
    let(:expected_hash) { { "transition" => "fade" } }
    
    it "should assign value to the key into the hash" do
      hash = {}
      subject.apply(term,hash)
      hash.should eq expected_hash
    end
    
  end

end
