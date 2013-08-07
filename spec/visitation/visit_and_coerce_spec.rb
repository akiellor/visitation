describe Visitation::Visitors do
  describe "#visit_and_coerce" do
    it "should coerce top level leaves" do
      left = {:blue => 2}
      right = {:blue => 100}

      result = Visitation::Visitors.visit_and_coerce(left, right) { |a, b| b * a }

      result.view.should == {:blue => 200}
    end

    it "should coerce nested leaves" do
      left = {:blue => 2, :red => {:green => 5}}
      right = {:blue => 100, :red => {:green => 6}}

      result = Visitation::Visitors.visit_and_coerce(left, right) { |a, b| b * a }

      result.view.should == {:blue => 200, :red => {:green => 30}}
    end
  end

  describe "default configuration" do
    it "should use the default configurations coercer when no coercer provided" do
      left = {:blue => 2}
      right = {:blue => 100}

      result = Visitation::Visitors.visit_and_coerce(left, right)

      result.view.should == {:blue => 2}
    end
  end
end
