module Assumption
  class Result
    private
    def initialize(lack, surplus)
      @lack = lack
      @surplus = surplus 
    end

    def valid?
      @lack.blank? && @surplus.blank?
    end
    public :valid?

    def result
      {:lack => @lack, :surplus => @surplus}
    end

    def inspect
      result.inspect
    end
    public :inspect
  end
end
