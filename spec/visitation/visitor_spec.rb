describe Visitation::Visitor do
  it "should not visit children of array when control says dont_go_deeper!" do
    visitor = Object.new
    def visitor.leaves
      @leaves ||= []
    end

    def visitor.visit_array key, value, control
      control.dont_go_deeper!
    end

    def visitor.visit_leaf key, value
      leaves << value
    end

    document = {:a => [1, 2, 3]}

    Visitation::Visitor.visit document, visitor

    visitor.should have(0).leaves
  end

  it "should not visit children of hash when control says dont_go_deeper!" do
    visitor = Object.new
    def visitor.leaves
      @leaves ||= []
    end

    def visitor.visit_hash key, value, control
      control.dont_go_deeper!
    end

    def visitor.visit_leaf key, value
      leaves << value
    end

    document = [{:a => 1}]

    Visitation::Visitor.visit document, visitor

    visitor.should have(0).leaves
  end

  it "should not visit children of root when control says dont_go_deeper!" do
    visitor = Object.new
    def visitor.leaves
      @leaves ||= []
    end

    def visitor.visit_root value, control
      control.dont_go_deeper!
    end

    def visitor.visit_leaf key, value
      leaves << value
    end

    document = [1, 2, 3, 4]

    Visitation::Visitor.visit document, visitor

    visitor.should have(0).leaves
  end

  context "falsey values" do
    [nil, false].each do |value|
      it "should visit #{value.inspect}" do
        visitor = Object.new
        def visitor.leaves
          @leaves ||= []
        end

        def visitor.visit_leaf key, value
          leaves << [key, value]
        end

        document = {:a => value}

        Visitation::Visitor.visit document, visitor

        visitor.leaves.should == [[:a, value]]
      end
    end
  end
end
