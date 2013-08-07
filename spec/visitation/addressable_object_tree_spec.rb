describe Visitation::AddressableObjectTree do
  AddressableObjectTree = Visitation::AddressableObjectTree

  it "should get a value" do
    tree_data = {
        "a" => {
            "b" => 10
        }
    }
    addressable_object_tree = AddressableObjectTree.new(tree_data)
    address = Address.new(["a"])
    addressable_object_tree.get(address).should == {"b" => 10}
  end

  it "should indicate that an address with a value exists" do
    addressable_object_tree = AddressableObjectTree.new({"a" => {"b" => 10}})

    addressable_object_tree.should have_address Address.new(["a"])
  end

  it "should indicate that an address without a value exists" do
    addressable_object_tree = AddressableObjectTree.new({"a" => nil})

    addressable_object_tree.should have_address Address.new(["a"])
  end

  it "should indicate that a deep missing address does not exist" do
    addressable_object_tree = AddressableObjectTree.new({"a" => nil})

    addressable_object_tree.should_not have_address Address.new(["a", "b"])
  end

  it "should indicate that a missing address does not exist" do
    addressable_object_tree = AddressableObjectTree.new({"b" => 1})

    addressable_object_tree.should_not have_address Address.new(["a"])
  end

  it "should have an array address" do
    addressable_object_tree = AddressableObjectTree.new([1, 2, 3, 4])

    addressable_object_tree.should have_address Address.new([0])
  end

  it "should replace node" do
    initial = {
        "a" => {
            "b" => 10
        }
    }
    expected = {
        "a" => {
            "c" => 15
        }
    }
    replacement = {
        "c" => 15
    }
    addressable_object_tree = AddressableObjectTree.new(initial)
    address = Address.new(["a"])

    addressable_object_tree.replace(address, replacement)

    addressable_object_tree.unwrap.should == expected
  end

  it "should put at the specified address without key" do
    object_tree = AddressableObjectTree.new({})

    object_tree.put Address.new(["foo", "bar", "baz"]), 5

    object_tree.unwrap.should == {"foo" => {"bar" => {"baz" => 5}}}
  end

  it "should put the desired object at the root" do
    object_tree = AddressableObjectTree.new([])

    object_tree.put Address.new, 5

    object_tree.unwrap.should == 5
  end

  it "should put the desired object at the root" do
    object_tree = AddressableObjectTree.new({})

    object_tree.put Address.new(%w{foo bar}), 5

    object_tree.unwrap.should == {"foo" => {"bar" => 5}}
  end

  it "should yield the node at location" do
    object_tree = AddressableObjectTree.new({:a => 1})

    nodes = object_tree.enum_for(:with_node_at, Address.new([:a])).to_a

    nodes.should == [1]
  end

  it "should yield nothing when the address does not exist" do
    object_tree = AddressableObjectTree.new({:a => 1})

    nodes = object_tree.enum_for(:with_node_at, Address.new([:b])).to_a

    nodes.should == []
  end

  it "should yield nothing when the address does not exist" do
    object_tree = AddressableObjectTree.new({:b => nil})

    nodes = object_tree.enum_for(:with_node_at, Address.new([:b])).to_a

    nodes.should == [nil]
  end
end
