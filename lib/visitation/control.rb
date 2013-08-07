module Visitation
  class Control
    def initialize
      @go_deeper = true
    end

    def go_deeper?
      @go_deeper
    end

    def dont_go_deeper!
      @go_deeper = false
    end
  end
end


