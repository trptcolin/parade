require_relative 'spec_helper'

describe Parade::Metadata::CSSClasses do

  describe "#match?" do
    it "should match a `term`" do
      subject.match?("term").should be_true
    end
  end

  describe "#apply" do
    let(:first_term) { "first_class" }
    let(:second_term) { "second_class" }
    let(:expected_hash) { { :classes => [ "first_class", "second_class" ] } }

    it "should assign value to the classes key into the hash" do
      hash = {}
      subject.apply(first_term,hash)
      subject.apply(second_term,hash)
      hash.should eq expected_hash
    end

  end

end
