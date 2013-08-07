describe Visitation::Visitors do
  describe "#visit_for_view" do
    it "extracts top level primitive attributes into view" do
      input = {"wantedPrimitive" => 0, "unwantedPrimitive" => 10}
      description = {"wantedPrimitive" => 5}
      expected = {"wantedPrimitive" => 0}

      visitor = Visitation::Visitors.visit_for_view input, description

      visitor.view.should == expected
    end

    it "extracts top level maps into view" do
      input = {"wantedMap" => {"wantedAttribute" => "value"}, "unwantedMap" => {"someOtherThing" => 10}}
      description = {"wantedMap" => {"wantedAttribute" => "something"}}
      expected = {"wantedMap" => {"wantedAttribute" => "value"}}

      visitor = Visitation::Visitors.visit_for_view input, description

      visitor.view.should == expected
    end

    it "extracts top level maps into view even if description is empty" do
      input = {"wantedMap" => {"a" => "b"}, "unwantedMap" => {"c" => "d"}}
      description = {"wantedMap" => {}}
      expected = {"wantedMap" => {"a" => "b"}}

      visitor = Visitation::Visitors.visit_for_view input, description

      visitor.view.should == expected
    end

    it "extracts top level arrays into view even if description is empty" do
      input = {"wantedArray" => [1, 2, 3], "unwantedArray" => [6, 7, 8]}
      description = {"wantedArray" => []}
      expected = {"wantedArray" => [nil, nil, nil]}

      visitor = Visitation::Visitors.visit_for_view input, description

      visitor.view.should == expected
    end

    it "extracts desired nils" do
      input = {
          "expectedNilAttribute" => "some string",
          "expectedNilArray" => [1, 2],
          "expectedNilObject" => {"key" => nil, "value" => nil},
          "unwantedAttribute" => "whatever"
      }
      description = {"expectedNilAttribute" => nil, "expectedNilArray" => nil, "expectedNilObject" => nil}
      expected = {
          "expectedNilAttribute" => "some string",
          "expectedNilArray" => [1, 2],
          "expectedNilObject" => {"key" => nil, "value" => nil}
      }

      visitor = Visitation::Visitors.visit_for_view input, description

      visitor.view.should == expected
    end

    it "includes nil for array elements without description" do
      input = { :a => [1, 2] }
      description = { :a => [9] }
      expected = { :a => [1, nil] }

      visitor = Visitation::Visitors.visit_for_view input, description

      visitor.view.should == expected
    end

    it "handles all the other cases until we write more unit tests" do
      input = {
          "key1" => "value1",
          "key2" => "value2",
          "key3" => {
              "child3" => 5
          },
          "nested1" => {
              "key3" => "value3",
              "object1" => [
                  {"first" => 1,
                   "second" => 2},
                  {"first" => 3,
                   "second" => 4}]
          },
          "nested2" => {
              "object2" => [4, 3]
          },
          "topLevelNotNeeded" => [1, 2],
          "topLevelNeeded" => [6, 7],
          "shouldBeEmpty" => []
      }
      description = {
          "key1" => "value1",
          "nested1" => {
              "key3" => "value3",
              "object1" => [
                  {"first" => 1},
                  {"first" => 3}]
          },
          "nested2" => {
              "object2" => [4, 3]
          },
          "topLevelNeeded" => [6, 7],
          "shouldBeEmpty" => []
      }
      expected = description

      visitor = Visitation::Visitors.visit_for_view input, description

      visitor.view.should == expected
    end
  end
end
