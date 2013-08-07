require 'enumerator'

describe Visitation::Address do
  Address = Visitation::Address

  it "allows objects to be pushed onto it" do
    Address.new.push("location").should == Address.new(["location"])
  end

  it "returns the underlying array" do
    Address.new.push(:key).push(0).get.should == [:key, 0]
  end

  it "should have frozen underlying array" do
    Address.new.push(:key).push(0).get.should be_frozen
  end

  it "returns an address over the parent" do
    Address.new.push(:parent).push(:child).parent.should == Address.new([:parent])
  end

  it "returns the locator at the head of the address" do
    Address.new.push("parent").push("child").head.should == "child"
  end

  it "should yield each of its sub-addresses from root to leaf" do
    Address.new(%w(foo bar baz)).enum_for(:descend).to_a.should == [
        Address.new(%w(foo)),
        Address.new(%w(foo bar)),
        Address.new(%w(foo bar baz))
    ]
  end

  it "should be the root" do
    Address.new.should be_root
  end

  it "should not be the root" do
    Address.new(%w{"foo"}).should_not be_root
  end

  context "parenting" do
    subject { address }

    let(:root) { Address.new(%w{}) }

    let(:address) { Address.new(%w{foo bar}) }

    its(:parent) { should be_parent_of(address) }

    it { should_not be_parent_of(address) }

    it { should_not be_parent_of(address.parent) }

    it "root should be parent of all things" do
      root.should be_parent_of address
    end
  end
end
