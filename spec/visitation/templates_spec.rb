describe Visitation::Visitors do
  describe "#template" do
    it "should replace template variables with specified data values" do
      template = {:a => 5, :b => 9}
      data = {:a => 7}

      result = Visitation::Visitors.merge_template template, data

      result.should == {:a => 7, :b => 9}
    end

    it "should replace template nested variables with specified data values" do
      template = {:a => {:b => 5, :c => 7}}
      data = {:a => {:b => 6}}

      result = Visitation::Visitors.merge_template template, data

      result.should == {:a => {:b => 6, :c => 7}}
    end

    it "should use first element of template collection to fill specified collection" do
      template = {:a => [{:b => 5, :c => 0}]}
      data = {:a => [{:b => 6, :c => 7}, {:c => 8}]}

      result = Visitation::Visitors.merge_template template, data

      result.should == {:a => [{:b => 6, :c => 7}, {:b => 5, :c => 8}]}
    end

    it "should use first element of template collection to fill specified nested collection" do
      template = {
          :a => [{
            :b => 5,
            :c => [{:d => 7, :e => 8}]
          }]
      }
      data = {
          :a => [
              {:b => 6, :c => [{:d => 10, :e => 12}]},
              {:c => [{:d => 10}]}
          ]
      }

      result = Visitation::Visitors.merge_template template, data

      result.should == {
          :a => [
              {:b => 6, :c => [{:d => 10, :e => 12}]},
              {:b => 5, :c => [{:d => 10, :e => 8}]}
          ]
      }
    end

    it "should result in empty collection when specified empty collection data values" do
      template = {:a => [{:b => 5, :c => 0}]}
      data = {:a => []}

      result = Visitation::Visitors.merge_template template, data

      result.should == {:a => []}
    end

    it "should result in template collection value when unspecified collection data values" do
      template = {:a => [{:b => 5, :c => 0}]}
      data = {}

      result = Visitation::Visitors.merge_template template, data

      result.should == {:a => [{:b => 5, :c => 0}]}
    end

    it "should replace default value with nil" do
      template = {:a => [{:b => 5, :c => 0}]}
      data = {:a => nil}

      result = Visitation::Visitors.merge_template template, data

      result.should == {:a => nil}
    end

    it "should replace default value with something else" do
      template = {:a => [{:b => 5, :c => 0}]}
      data = {:a => 4}

      result = Visitation::Visitors.merge_template template, data

      result.should == {:a => 4}
    end

    it "should remove template variables when indicated by specified data values"

    it "should explode when specified data values have no template variable"
    it "should explode when specified data values have no template nested variable"
  end
end
