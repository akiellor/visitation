require 'visitation/matchers'

describe Visitation::Matchers do
  include Visitation::Matchers

  after(:each) do
    Visitation.reset_configuration
  end

  describe "#match_description" do
    it "should match subtree" do
      hash = {:blue => 1, :red => 4}

      description = {:blue => 1}

      hash.should match_description description
    end

    it "should not match subtree" do
      hash = {:blue => 1, :red => 4}

      description = {:blue => 2}

      hash.should_not match_description description
    end

    it "should match subtree with coercion" do
      Visitation.configure do
        coerce_with {|a, b| a.to_s }
      end

      hash = {:blue => "1", :red => 4}

      description = {:blue => 1}

      hash.should match_description description
    end

    it "should not match when only the first element is in description" do
      hash = {:colors => [ {:red => 2}, {:green => 5} ]}

      description = {:colors => [ {:red => 2} ]}

      hash.should_not match_description description
    end

    it "should not match when only the second element is in description" do
      hash = {:colors => [ {:red => 2}, {:green => 5} ]}

      description = {:colors => [ {:green => 5} ]}

      hash.should_not match_description description
    end

    it "should not match when elements are described out of order with different keys" do
      hash = {:colors => [ {:red => 2}, {:green => 5} ]}

      description = {:colors => [ {:green => 5}, {:red => 2} ]}

      hash.should_not match_description description
    end

    it "should not match when elements are described out of order with equal keys" do
      hash = {:colors => [ {:red => 2}, {:red => 5} ]}

      description = {:colors => [ {:red => 5}, {:red => 2} ]}

      hash.should_not match_description description
    end
  end
end
