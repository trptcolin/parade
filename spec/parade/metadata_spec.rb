require_relative 'spec_helper'

describe Parade::Metadata do

  let(:metadata) { "transition=fade one two #id three tpl=custom" }
  subject { described_class.parse metadata }

  let(:expected_transition) { "fade" }
  its(:transition) { should eq expected_transition }

  let(:expected_classes) { [ "one", "two", "three" ] }
  its(:classes) { should eq expected_classes }

  let(:expected_id) { "id" }
  its(:id) { should eq expected_id }

  let(:expected_template) { "custom" }
  its(:template) { should eq expected_template }

  context "when created with no metadata" do
    subject { described_class.new }

    its(:classes) { should eq [] }
    its(:transition) { should eq nil }
    its(:id) { should eq nil }
  end

end
