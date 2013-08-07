describe Visitation::Control do
  it "should go deeper" do
    control = Visitation::Control.new

    control.go_deeper?.should be_true
  end

  it "should not go deeper" do
    control = Visitation::Control.new

    control.dont_go_deeper!

    control.go_deeper?.should be_false
  end
end
