include Visitation::Visitors
include Visitation

describe Visitation::Visitors::DeepMergingVisitor do
  context "identifier" do
    it "should get the identifier from the document" do
      document = {:a => 1, :b => 2}

      id = DeepMergingVisitor::Identifier.new(Address.new, Address.new([:a])).get(document)

      id.should == [1]
    end
  end

  context "basic hashes" do
    it "should replace key existing in both hashes" do
      document = {:a => 2}
      partial = {:a => 1}

      result = Visitation::Visitors.visit_and_deep_merge document, partial

      result.should == {:a => 1}
    end

    it "should retain values from document hash when missing in partial" do
      document = {:b => 2, :a => 4}
      partial = {:a => 1}

      result = Visitation::Visitors.visit_and_deep_merge document, partial

      result.should == {:a => 1, :b => 2}
    end

    it "should add properties not present in original document" do
      document = {:b => 2, :a => 4}
      partial = {:c => 1}

      result = Visitation::Visitors.visit_and_deep_merge document, partial

      result.should == {:a => 4, :b => 2, :c => 1}
    end
  end

  context "basic arrays" do
    it "should replace element at index" do
      document = [1, 2, 3]
      partial = [5]

      result = Visitation::Visitors.visit_and_deep_merge document, partial

      result.should == [5, 2, 3]
    end
  end

  context "nesting" do
    it "should merge a nested document" do
      document = {:a => [{:b => 1, :c => 2}, {:d => 7}]}
      partial = {:a => [{:b => 7}, {:d => 9}]}

      result = Visitation::Visitors.visit_and_deep_merge document, partial

      result.should == {:a => [{:b => 7, :c => 2}, {:d => 9}]}
    end
  end

  context "merging collection with identifiers" do
    it "should merge the correct array element when identifiers specified" do
      pending
      document = { :people => [{:id => 2, :name => "Tom"}, {:id => 1, :name => "Fred"}] }
      partial = { :people => [{:id => 1, :name => "Fred Jr."}] }

      identifier = DeepMergingVisitor::Identifier.new(Address.new([:people]), Address.new([:id]))

      result = Visitation::Visitors.visit_and_deep_merge document, partial, [identifier]

      result.should == { :people => [{:id => 2, :name => "Tom"}, {:id => 1, :name => "Fred Jr."}] }
    end


    it "should merge the correct array element when identifiers specified" do
      document = [{:id => 2, :name => "Tom"}, {:id => 1, :name => "Fred"}]
      partial = [{:id => 1, :name => "Fred Jr."}]

      identifier = DeepMergingVisitor::Identifier.new(Address.new, Address.new([:id]))

      result = Visitation::Visitors.visit_and_deep_merge document, partial, [identifier]

      result.should == [{:id => 2, :name => "Tom"}, {:id => 1, :name => "Fred Jr."}]
    end


    examples = [
        {:document => [{:id => 1, :name => "Fred", :age => 7}, {:id => 1, :name => "Tom", :age => 5}],
        :partial => [{:id => 1, :name => "Tom", :age => 12}],
        :output => [{:id => 1, :name => "Fred", :age => 7}, {:id => 1, :name => "Tom", :age => 12}]},

        {:document => [{:id => 2, :name => "Tom", :age => 7}, {:id => 1, :name => "Tom", :age => 5}],
         :partial => [{:id => 1, :name => "Tom", :age => 12}],
         :output => [{:id => 1, :name => "Tom", :age => 12}, {:id => 2, :name => "Tom", :age => 7}]}
    ]

    examples.each do |example|
      it "should merge the correct array element when multiple identifiers specified" do
        document = example[:document].shuffle
        partial = example[:partial]

        identifier = DeepMergingVisitor::Identifier.new(Address.new, Address.new([:id]), Address.new([:name]))

        result = Visitation::Visitors.visit_and_deep_merge document, partial, [identifier]

        Set.new(result).should == Set.new(example[:output])
      end
    end
  end
end
