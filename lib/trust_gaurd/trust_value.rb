module TrustGaurd
  class TrustValue
    # Initializes some constants used to calculate the trust value.
    #
    # alpha specifies the weight applied to the current raw trust value.
    # beta specifies the weight applied to previous raw trust values.
    # pos_gamma is the weight applied to the change between the current raw trust value and all previous raw trust values when the change is not negative.
    # neg_gamma is the weight applied to the change between the current raw trust value and all previous raw trust values when the change is negative.
    # p is used to degrade the weight of previous raw trust values based upon how far they are from the current raw trust value.
    #
    # Some notes about varying these values:
    #   When alpha > beta, history does not have as much significance as the current value. The opposite is also true.
    #   When pos_gamma is large, it is easier to obtain a higher trust value over time. The authors that propose this algorithm suggest that it be hard to get a good reputation.
    #   When pos_gamma is large, there is a large penalty for a bad reputation. The authors that propose this algorithm suggest that reputation be lost quickly if the raw trust history decreases radically.
    #   When p = 1, all previous raw trust values are treated equally. Generally, more recent ones should have more significance. Therefore, a p value < 1 is preferable.
    def initialize(alpha, beta, pos_gamma, neg_gamma, p)
      @alpha, @beta, @pos_gamma, @neg_gamma, @p = alpha, beta, pos_gamma, neg_gamma, p
      setup_memo!
    end

    # Calculates the trust value based upon the raw reputations over multiple periods.
    def calculate(raw_reputations)
      @time, @raw_reps = raw_reputations.size - 1, raw_reputations
      setup_memo!
      @alpha * @raw_reps[@time] + @beta * history_reputation + gamma(change_factor) * change_factor
    end
    
    private
    
    def history_reputation
      @memo[:history_reputation] ||= summation(1...@raw_reps.size) {|i| @raw_reps[@time - i] * weighting(i)}
    end
    
    def weighting(i)
      w = ->(i){ @memo[:w][i] ||= @p**(i-1)}
      @memo[:weighted_total] ||= summation(1...@raw_reps.size) {|j| w[j]}
      w[i] / @memo[:weighted_total]
    end
    
    def gamma(change)
      change < 0 ? @neg_gamma : @pos_gamma
    end
    
    def change_factor
      return 0 if @raw_reps.size <= 1 
      @memo[:change_factor] ||= @raw_reps[@time] - history_reputation
    end
    
    def setup_memo!
      @memo = {:w => []}
    end
    
    def summation(range)
      range.inject(0) do |memo, i|
        yield(i) + memo
      end
    end
  end
end