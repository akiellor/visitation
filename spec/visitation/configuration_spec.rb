describe Visitation::Configuration do
  after(:each) do
    Visitation.reset_configuration
  end

  it "should set up the default coercion strategy" do
    Visitation.configure do
      coerce_with {|a, b| a.to_s }
    end

    Visitation.coercer.call(100, 200).should == "100"
  end

  it "should have a default coercion strategy" do
    Visitation.coercer.call(100, 200).should == 100
  end
end
