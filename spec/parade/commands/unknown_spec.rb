require_relative 'spec_helper'

describe Parade::Commands::Unknown do
  
  its(:description) { should eq "Could not find the command specified" }
  
  describe "#generate" do
    it "should generate a message" do
      subject.should_receive(:puts).with subject.description
      subject.generate({})
    end
  end
end
