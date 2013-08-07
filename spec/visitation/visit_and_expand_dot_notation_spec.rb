describe Visitation::Visitors do
  describe "#visit_and_expand_dot_notation" do
    it "should expand dot notation" do
      collapsed = {"blue.red.green" => 2}

      result = Visitation::Visitors.visit_and_expand_dot_notation(collapsed)

      result.get.should == {'blue' => {'red' => {'green' => 2}}}
    end
  end
end
