require_relative '../spec_helper'

shared_examples "a properly parsed section" do
  it "should have the correct title" do
    section.title.should eq title
  end

  it "should have the correct number of slides" do
    section.slides.count.should eq slide_count
  end
end